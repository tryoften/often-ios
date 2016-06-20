[Changelog](https://github.com/kean/Nuke/releases) for all versions

## Nuke 3.1.0

- #64 Fix a performance regression: images are now decoded once per DataTask like they used to
- #65 Fix an issue custom on-disk cache (`ImageDiskCaching`) was called `setData(_:response:forTask:)` method when the error wasn't nil
- Add notifications for NSURLSessionTask state changes to enable activity indicators (based on https://github.com/kean/Nuke-Alamofire-Plugin/issues/4)

## Nuke 3.0.0

- Update for Swift 2.2
- Move `ImagePreheatingController` to a standalone package [Preheat](https://github.com/kean/Preheat)
- Remove deprecated `suspend` method from `ImageTask`
- Remove `ImageFilterGaussianBlur` and Core Image helper functions which are now part of [Core Image Integration Guide](https://github.com/kean/Nuke/wiki/Core-Image-Integration-Guide)
- Cleanup project structure (as expected by SPM)
- `ImageManager` constructor now has a default value for configuration
- `nk_setImageWith(URL:)` method no longer resizes images by default, because resizing is not effective in most cases
- Remove `nk_setImageWith(request:options:placeholder:)` method, it's trivial
- `ImageLoadingView` default implementation no longer implements "Cross Dissolve" animations, use `ImageViewLoadingOptions` instead (see `animations` or `handler` property)
- Remove `ImageViewDefaultAnimationDuration`, use `ImageViewLoadingOptions` instead (see `animations` property)
- `ImageDisplayingView` protocol now has a single `nk_displayImage(_)` method instead of a `nk_image` property
- Remove `nk_targetSize` property from `UI(NS)View` extension

## Nuke 2.3.0

- #60 Add custom on-disk caching support (see `ImageDiskCaching` protocol)
- Reduce dynamic dispatch

## Nuke 2.2.0

- `ImageTask` `suspend` method is deprecated, implementation does nothing
- `ImageLoader` now limits a number of concurrent `NSURLSessionTasks`
- Add `maxConcurrentSessionTaskCount` property to `ImageLoaderConfiguration`
- Add `taskReusingEnabled` property to `ImageLoaderConfiguration`
- Add [Swift Package Manager](https://swift.org/package-manager/) support
- Update documentation

## Nuke 2.1.0
 
- #57 `ImageDecompressor` now uses `CGImageAlphaInfo.NoneSkipLast` for opaque images 
- Add `ImageProcessorWithClosure` that can be used for creating anonymous image filters
- `ImageLoader` ensures thread safety of image initializers by running decoders on a `NSOperationQueue` with `maxConcurrentOperationCount=1`. However, `ImageDecoder` class is now also made thread safe.

## Nuke 2.0.1

- #53 ImageRequest no longer uses NSURLSessionTaskPriorityDefault, which requires CFNetwork that doesn't get added as a dependency automatically

## Nuke 2.0

Nuke now has an [official website](http://kean.github.io/Nuke/)!

#### Main Changes

- #48 Update according to [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). All APIs now just feel right.
- Add `UIImage` extension with helper functions for `Core Image`: `nk_filter(_:)`, etc.
- Add `ImageFilterGaussianBlur` as an example of a filter on top of `Core Image` framework
- Add `ImageRequestMemoryCachePolicy` enum that specifies the way `ImageManager` interacts with a memory cache; `NSURLRequestCachePolicy` no longer affects memory cache
- #17 Add `priority` to `ImageRequest`
- Add `removeResponseForKey()` method to `ImageMemoryCaching` protocol and the corresponding method to `ImageManager`
- Implement congestion control for `ImageLoader` that prevents `NSURLSession` trashing
- Simplify `ImageLoaderDelegate` by combining methods that were customizing processing in a single high-level method: `imageLoader(_:processorFor:image:)`. Users now have more control over processing
- Add `NSURLResponse?` parameter to `decode` method from `ImageDecoding` protocol
- `ImageDataLoading` protocol no longer has `isLoadEquivalentRequest(_:toRequest)` and `isCacheEquivalentRequest(_:toRequest)`. Those methods are now part of `ImageLoaderDelegate` and they have default implementation
- `ImageResponseInfo` is now a struct
- Improved error reporting (codes are now stored in enum, more codes were added, error is now created with a failure reason)

#### UI Extensions Changes
- Move `nk_imageTask(_:didFinishWithResponse:options)` method to `ImageLoadingView` protocol, that's really where it belongs to
- Add `handler` property to `ImageViewLoadingOptions` that allows you to completely override display/animate logic in `ImageLoadingView`
- Remove `nk_prepareForReuse` method from `ImageLoadingView` extensions (useless)
- Remove `placeholder` from `ImageViewLoadingOptions`, move it to a separate argument which is only available on `ImageDisplayingView`s
- Add `animated`, `userInfo` to `ImageViewLoadingOptions`
- `ImageViewLoadingOptions` is now nonull everywhere
- Add `setImageWith(task:options:)` method to `ImageViewLoadingController`

#### Other Changes

- If you add a completion handler for completed task, the response is now marked as `isFastResponse = true`
- Fix an issue that allowed incomplete image downloads to finish successfully when using built-in networking
- `equivalentProcessors(rhs:lhs:)` function is now private (and it also is renamed)
- Remove public `isLoadEquivalentToRequest(_:)` and `isCacheEquivalentToRequest(_:)` methods from `ImageRequest` extension
- Add `ImageTaskProgress` struct that represents load progress, move `fractionCompleted` property from `ImageTask` to `ImageTaskProgress`
- Remove public helper function `allowsCaching` from `ImageRequest` extension
- Remove deprecated `XCPSetExecutionShouldContinueIndefinitely` from playground

## Nuke 1.4.0

- #46 Add option to disable memory cache storage, thanks to @RuiAAPeres

## Nuke 1.3.0

- Add [Core Image Integration Guide](https://github.com/kean/Nuke/wiki/Core-Image-Integration-Guide)
- Fill most of the blanks in the documentation
- #47 Fix target size rounding errors in image downscaling (Pyry Jahkola @pyrtsa)
- Add `imageScale` property to `ImageDecoder` class that returns scale to be used when creating `UIImage` (iOS, tvOS, watchOS only)
- Wrap each iteration in `ImageProcessorComposition` in an `autoreleasepool`


## Nuke 1.2.0

- #20 Add preheating for UITableView (see ImagePreheatingControllerForTableView class)
- #41 Enhanced tvOS support thanks to @joergbirkhold
- #39 UIImageView: ImageLoadingView extension no available on tvOS
- Add factory method for creating session tasks in ImageDataLoader
- Improved documentation


## Nuke 1.1.1

- #35 ImageDecompressor now uses `32 bpp, 8 bpc, CGImageAlphaInfo.PremultipliedLast` pixel format which adds support for images in an obscure formats, including 16 bpc images.
- Improve docs


## Nuke 1.1.0

- #25 Add tvOS support
- #33 Add app extensions support for OSX target (other targets were already supported)


## Nuke 1.0.0

- #30 Add new protocols and extensions to make it easy to add full featured image loading capabilities to custom UI components. Here's how it works:
```swift
extension MKAnnotationView: ImageDisplayingView, ImageLoadingView {
    // That's it, you get default implementation of all the methods in ImageLoadingView protocol
    public var nk_image: UIImage? {
        get { return self.image }
        set { self.image = newValue }
    }
}
```
- #30 Add UIImageView extension instead of custom UIImageView subclass
- Back to the Mac! All new protocol and extensions for UI components (#30) are also available on a Mac, including new NSImageView extension.
- #26 Add `getImageTaskWithCompletion(_:)` method to ImageManager
- Add essential documentation
- Add handy extensions to ImageResponse
