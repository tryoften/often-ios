// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

import Foundation

/**
The domain used for creating all ImageManager errors.

The image manager would produce either errors in ImageManagerErrorDomain or errors in NSURLErrorDomain (which are not wrapped).
 */
public let ImageManagerErrorDomain = "Nuke.ImageManagerErrorDomain"

/// The image manager error codes.
public enum ImageManagerErrorCode: Int {
    /// Returned when the image manager encountered an error that it cannot interpret.
    case unknown = -15001

    /// Returned when the image task gets cancelled.
    case cancelled = -15002
    
    /// Returned when the image manager fails decode image data.
    case decodingFailed = -15003
    
    /// Returned when the image manager fails to process image data.
    case processingFailed = -15004
}

// MARK: - ImageManagerConfiguration

/// Configuration options for an ImageManager.
public struct ImageManagerConfiguration {
    /// Performs loading of images.
    public var loader: ImageLoading

    /// In-memory storage for image responses.
    public var cache: ImageMemoryCaching?
    
    /// Default value is 2.
    public var maxConcurrentPreheatingTaskCount = 2
    
    /**
     Initializes configuration with an image loader and memory cache.
     
     - parameter loader: Image loader.
     - parameter cache: Memory cache. Default `ImageMemoryCache` instance is created if the parameter is omitted.
     */
    public init(loader: ImageLoading, cache: ImageMemoryCaching? = ImageMemoryCache()) {
        self.loader = loader
        self.cache = cache
    }
    
    /**
     Convenience initializer that creates instance of `ImageLoader` class with a given `dataLoader` and `decoder`, then calls the default initializer.
     
     - parameter dataLoader: Image data loader.
     - parameter decoder: Image decoder. Default `ImageDecoder` instance is created if the parameter is omitted.
     - parameter cache: Memory cache. Default `ImageMemoryCache` instance is created if the parameter is omitted.
     */
    public init(dataLoader: ImageDataLoading, decoder: ImageDecoding = ImageDecoder(), cache: ImageMemoryCaching? = ImageMemoryCache()) {
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: dataLoader, decoder: decoder))
        self.init(loader: loader, cache: cache)
    }
}

// MARK: - ImageManager

/**
The `ImageManager` class and related classes provide methods for loading, processing, caching and preheating images.

`ImageManager` is also a pipeline that loads images using injectable dependencies, which makes it highly customizable. See https://github.com/kean/Nuke#design for more info.
*/
public class ImageManager {
    private var executingTasks = Set<ImageTaskInternal>()
    private var preheatingTasks = [ImageRequestKey: ImageTaskInternal]()
    private let lock = RecursiveLock()
    private var invalidated = false
    private var needsToExecutePreheatingTasks = false
    private var taskIdentifier: Int32 = 0
    private var nextTaskIdentifier: Int {
        return Int(OSAtomicIncrement32(&taskIdentifier))
    }
    private var loader: ImageLoading
    private var cache: ImageMemoryCaching?
    
    // MARK: Configuring Manager

    /// The configuration that the receiver was initialized with.
    public let configuration: ImageManagerConfiguration

    /// Initializes image manager with a given configuration. ImageManager becomes a delegate of the ImageLoader.
    public init(configuration: ImageManagerConfiguration = ImageManagerConfiguration(dataLoader: ImageDataLoader())) {
        self.configuration = configuration
        self.cache = configuration.cache
        self.loader = configuration.loader
        self.loader.manager = self
    }
    
    // MARK: Adding Tasks
    
    /**
     Creates a task with a given request. After you create a task, you start it by calling its resume method.
     
     The manager holds a strong reference to the task until it is either completes or get cancelled.
     */
    public func taskWith(_ request: ImageRequest) -> ImageTask {
        return ImageTaskInternal(manager: self, request: request, identifier: nextTaskIdentifier)
    }
    
    // MARK: FSM (ImageTaskState)
    
    private func setState(_ state: ImageTaskState, forTask task: ImageTaskInternal)  {
        if task.isValidNextState(state) {
            transitionStateAction(task.state, toState: state, task: task)
            task.state = state
            enterStateAction(state, task: task)
        }
    }
    
    private func transitionStateAction(_ fromState: ImageTaskState, toState: ImageTaskState, task: ImageTaskInternal) {
        if fromState == .running && toState == .cancelled {
            loader.cancelLoadingFor(task)
        }
    }
    
    private func enterStateAction(_ state: ImageTaskState, task: ImageTaskInternal) {
        switch state {
        case .running:
            if task.request.memoryCachePolicy == .returnCachedImageElseLoad {
                if let response = responseForRequest(task.request) {
                    // FIXME: Should ImageResponse contain a `fastResponse` property?
                    task.response = ImageResponse.success(response.image, ImageResponseInfo(isFastResponse: true, userInfo: response.userInfo))
                    setState(.completed, forTask: task)
                    return
                }
            }
            executingTasks.insert(task) // Register task until it's completed or cancelled.
            loader.resumeLoadingFor(task)
        case .cancelled:
            task.response = ImageResponse.failure(errorWithCode(.cancelled))
            fallthrough
        case .completed:
            executingTasks.remove(task)
            setNeedsExecutePreheatingTasks()
            
            let completions = task.completions
            dispathOnMainThread {
                completions.forEach { $0(task.response!) }
            }
        default: break
        }
    }
    
    // MARK: Preheating
    
    /**
    Prepares images for the given requests for later use.
    
    When you call this method, ImageManager starts to load and cache images for the given requests. ImageManager caches images with the exact target size, content mode, and filters. At any time afterward, you can create tasks with equivalent requests.
    */
    public func startPreheatingImages(_ requests: [ImageRequest]) {
        perform {
            requests.forEach {
                let key = ImageRequestKey($0, owner: self)
                if preheatingTasks[key] == nil { // Don't create more than one task for the equivalent requests.
                    preheatingTasks[key] = ImageTaskInternal(manager: self, request: $0, identifier: nextTaskIdentifier).completion { [weak self] _ in
                        self?.preheatingTasks[key] = nil
                    }
                }
            }
            setNeedsExecutePreheatingTasks()
        }
    }
    
    /// Stop preheating for the given requests. The request parameters should match the parameters used in startPreheatingImages method.
    public func stopPreheatingImages(_ requests: [ImageRequest]) {
        perform {
            cancelTasks(requests.flatMap {
                return preheatingTasks[ImageRequestKey($0, owner: self)]
            })
        }
    }
    
    /// Stops all preheating tasks.
    public func stopPreheatingImages() {
        perform { cancelTasks(preheatingTasks.values) }
    }
    
    private func setNeedsExecutePreheatingTasks() {
        if !needsToExecutePreheatingTasks && !invalidated {
            needsToExecutePreheatingTasks = true
            DispatchQueue.main.after(when: DispatchTime.now() + Double(Int64((0.15 * Double(NSEC_PER_SEC)))) / Double(NSEC_PER_SEC)) {
                [weak self] in self?.perform {
                    self?.executePreheatingTasksIfNeeded()
                }
            }
        }
    }
    
    private func executePreheatingTasksIfNeeded() {
        needsToExecutePreheatingTasks = false
        var executingTaskCount = executingTasks.count
        // FIXME: Use sorted dictionary
        for task in (preheatingTasks.values.sorted { $0.identifier < $1.identifier }) {
            if executingTaskCount > configuration.maxConcurrentPreheatingTaskCount {
                break
            }
            if task.state == .suspended {
                setState(.running, forTask: task)
                executingTaskCount += 1
            }
        }
    }
    
    // MARK: Memory Caching
    
    /// Returns response from the memory cache.
    public func responseForRequest(_ request: ImageRequest) -> ImageCachedResponse? {
        return cache?.responseForKey(ImageRequestKey(request, owner: self))
    }
    
    /// Stores response into the memory cache.
    public func setResponse(_ response: ImageCachedResponse, forRequest request: ImageRequest) {
        cache?.setResponse(response, forKey: ImageRequestKey(request, owner: self))
    }
    
    /// Stores response from the memory cache.
    public func removeResponseForRequest(_ request: ImageRequest) {
        cache?.removeResponseForKey(ImageRequestKey(request, owner: self))
    }
    
    // MARK: Misc
    
    /// Cancels all outstanding tasks and then invalidates the manager. New image tasks may not be resumed.
    public func invalidateAndCancel() {
        perform {
            loader.manager = nil
            cancelTasks(executingTasks)
            preheatingTasks.removeAll()
            loader.invalidate()
            invalidated = true
        }
    }
    
    /// Removes all cached images by calling corresponding methods on memory cache and image loader.
    public func removeAllCachedImages() {
        cache?.clear()
        loader.removeAllCachedImages()
    }
    
    /// Returns all executing tasks and all preheating tasks. Set with executing tasks might contain currently executing preheating tasks.
    public var tasks: (executingTasks: Set<ImageTask>, preheatingTasks: Set<ImageTask>) {
        var executingTasks: Set<ImageTask>!
        var preheatingTasks: Set<ImageTask>!
        perform {
            executingTasks = self.executingTasks
            preheatingTasks = Set(self.preheatingTasks.values)
        }
        return (executingTasks, preheatingTasks)
    }


    // MARK: Misc
    
    private func perform(@noescape _ closure: (Void) -> Void) {
        lock.lock()
        if !invalidated { closure() }
        lock.unlock()
    }
    
    private func cancelTasks<T: Sequence where T.Iterator.Element == ImageTaskInternal>(_ tasks: T) {
        tasks.forEach { setState(.cancelled, forTask: $0) }
    }
}

extension ImageManager: ImageLoadingManager {
    
    // MARK: ImageManager: ImageLoadingManager

    /// Updates ImageTask progress on the main thread.
    public func loader(_ loader: ImageLoading, task: ImageTask, didUpdateProgress progress: ImageTaskProgress) {
        DispatchQueue.main.async(execute: {
            task.progress = progress
            task.progressHandler?(progress: progress)
        })

    }

    /// Completes ImageTask, stores the response in memory cache.
    public func loader(_ loader: ImageLoading, task: ImageTask, didCompleteWithImage image: Image?, error: ErrorProtocol?, userInfo: Any?) {
        let task = task as! ImageTaskInternal
        if let image = image {
            if task.request.memoryCacheStorageAllowed {
                setResponse(ImageCachedResponse(image: image, userInfo: userInfo), forRequest: task.request)
            }
            task.response = ImageResponse.success(image, ImageResponseInfo(isFastResponse: false, userInfo: userInfo))
        } else {
            task.response = ImageResponse.failure(error ?? errorWithCode(.unknown))
        }
        perform { setState(.completed, forTask: task) }
    }
}

extension ImageManager: ImageTaskManaging {
    
    // MARK: ImageManager: ImageTaskManaging
    
    private func resume(_ task: ImageTaskInternal) {
        perform { setState(.running, forTask: task) }
    }
    
    private func cancel(_ task: ImageTaskInternal) {
        perform { setState(.cancelled, forTask: task) }
    }
    
    private func addCompletion(_ completion: ImageTaskCompletion, forTask task: ImageTaskInternal) {
        perform {
            switch task.state {
            case .completed, .cancelled:
                dispathOnMainThread {
                    completion(task.response!.makeFastResponse())
                }
            default: task.completions.append(completion)
            }
        }
    }
}

extension ImageManager: ImageRequestKeyOwner {
    
    // MARK: ImageManager: ImageRequestKeyOwner

    /// Compares requests for cache equivalence.
    public func isEqual(_ lhs: ImageRequestKey, to rhs: ImageRequestKey) -> Bool {
        return loader.isCacheEquivalent(lhs.request, to: rhs.request)
    }
}

// MARK: - ImageTaskInternal

private protocol ImageTaskManaging {
    func resume(_ task: ImageTaskInternal)
    func cancel(_ task: ImageTaskInternal)
    func addCompletion(_ completion: ImageTaskCompletion, forTask task: ImageTaskInternal)
}

private class ImageTaskInternal: ImageTask {
    let manager: ImageTaskManaging
    var completions = [ImageTaskCompletion]()
    
    init(manager: ImageTaskManaging, request: ImageRequest, identifier: Int) {
        self.manager = manager
        super.init(request: request, identifier: identifier)
    }
    
    override func resume() -> Self {
        manager.resume(self)
        return self
    }
    
    override func cancel() -> Self {
        manager.cancel(self)
        return self
    }
    
    override func completion(_ completion: ImageTaskCompletion) -> Self {
        manager.addCompletion(completion, forTask: self)
        return self
    }

    func isValidNextState(_ nextState: ImageTaskState) -> Bool {
        switch (self.state) {
        case .suspended: return (nextState == .running || nextState == .cancelled)
        case .running: return (nextState == .completed || nextState == .cancelled)
        default: return false
        }
    }
}
