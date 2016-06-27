// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

import Foundation

// MARK: - ImageDataLoading

/// Data loading completion closure.
public typealias ImageDataLoadingCompletion = (data: Data?, response: URLResponse?, error: ErrorProtocol?) -> Void

/// Data loading progress closure.
public typealias ImageDataLoadingProgress = (completed: Int64, total: Int64) -> Void

/// Performs loading of image data.
public protocol ImageDataLoading {
    /// Creates task with a given request. Task is resumed by the object calling the method.
    func taskWith(_ request: ImageRequest, progress: ImageDataLoadingProgress, completion: ImageDataLoadingCompletion) -> URLSessionTask

    /// Invalidates the receiver.
    func invalidate()

    /// Clears the receiver's cache storage (in any).
    func removeAllCachedImages()
}


// MARK: - ImageDataLoader

/// Provides basic networking using NSURLSession.
public class ImageDataLoader: NSObject, URLSessionDataDelegate, ImageDataLoading {
    public private(set) var session: Foundation.URLSession!
    private var handlers = [URLSessionTask: DataTaskHandler]()
    private var lock = RecursiveLock()

    /// Initialzies data loader by creating a session with a given session configuration.
    public init(sessionConfiguration: URLSessionConfiguration) {
        super.init()
        self.session = Foundation.URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }

    /// Initializes the receiver with a default NSURLSession configuration and NSURLCache with memory capacity set to 0, disk capacity set to 200 Mb.
    public convenience override init() {
        let conf = URLSessionConfiguration.default()
        conf.urlCache = URLCache(memoryCapacity: 0, diskCapacity: (200 * 1024 * 1024), diskPath: "com.github.kean.nuke-cache")
        self.init(sessionConfiguration: conf)
    }
    
    // MARK: ImageDataLoading

    /// Creates task for the given request.
    public func taskWith(_ request: ImageRequest, progress: ImageDataLoadingProgress, completion: ImageDataLoadingCompletion) -> URLSessionTask {
        let task = taskWith(request)
        lock.lock()
        handlers[task] = DataTaskHandler(progress: progress, completion: completion)
        lock.unlock()
        return task
    }
    
    /// Factory method for creating session tasks for given image requests.
    public func taskWith(_ request: ImageRequest) -> URLSessionTask {
        return session.dataTask(with: request.URLRequest)
    }

    /// Invalidates the instance of NSURLSession class that the receiver was initialized with.
    public func invalidate() {
        session.invalidateAndCancel()
    }

    /// Removes all cached images from the instance of NSURLCache class from the NSURLSession configuration.
    public func removeAllCachedImages() {
        session.configuration.urlCache?.removeAllCachedResponses()
    }
    
    // MARK: NSURLSessionDataDelegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        lock.lock()
        if let handler = handlers[dataTask] {
            handler.data.append(data)
            handler.progress(completed: dataTask.countOfBytesReceived, total: dataTask.countOfBytesExpectedToReceive)
        }
        lock.unlock()
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        lock.lock()
        if let handler = handlers[task] {
            handler.completion(data: handler.data as Data, response: task.response, error: error)
            handlers[task] = nil
        }
        lock.unlock()
    }
}

private class DataTaskHandler {
    let data = NSMutableData()
    let progress: ImageDataLoadingProgress
    let completion: ImageDataLoadingCompletion
    
    init(progress: ImageDataLoadingProgress, completion: ImageDataLoadingCompletion) {
        self.progress = progress
        self.completion = completion
    }
}
