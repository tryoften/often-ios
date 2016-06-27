// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

import UIKit
import FLAnimatedImage
import Nuke
import ImageIO

/// Represents animated image.
public class AnimatedImage: UIImage {
    /// Image data that the receiver was initialized with.
    public let data: Data! // it's nonnull
    
    /// Initializes the receiver with a given data and poster image.
    public init(data: Data, poster: CGImage) {
        self.data = data
        super.init(cgImage: poster, scale: 1, orientation: .up)
    }
    
    /// Not implemented.
    public required init?(coder decoder: NSCoder) {
        self.data = nil // makes me sad
        super.init(coder: decoder)
    }
    
    /// Not implemented.
    public required convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }
}

/// Creates instances of `AnimatedImage` class from the given data. Checks if the image data is in a GIF image format, otherwise returns nil.
public class AnimatedImageDecoder: ImageDecoding {
    /// Initializer the receiver.
    public init() {}
    
    /// Decodes image data and returns an instance of AnimatedImage class.
    public func decode(_ data: Data, response: URLResponse?) -> Image? {
        guard self.isAnimatedGIFData(data) else {
            return nil
        }
        guard let poster = self.posterImageFor(data) else {
            return nil
        }
        return AnimatedImage(data: data, poster: poster)
    }
    
    /// Return true if the image data represents animated image in GIF format.
    public func isAnimatedGIFData(_ data: Data) -> Bool {
        let sigLength = 3
        if data.count < sigLength {
            return false
        }
        var sig = [UInt8](repeating: 0, count: sigLength)
        (data as NSData).getBytes(&sig, length:sigLength)
        return sig[0] == 0x47 && sig[1] == 0x49 && sig[2] == 0x46
    }
    
    private func posterImageFor(_ data: Data) -> CGImage? {
        if let source = CGImageSourceCreateWithData(data, nil) {
            return CGImageSourceCreateImageAtIndex(source, 0, nil)
        }
        return nil
    }
    
}

/// Extension that adds image loading capabilities to the FLAnimatedImageView.
public extension FLAnimatedImageView {
    /// Displays a given image. Starts animation if image is an instance of AnimatedImage.
    public override func nk_displayImage(_ image: Image?) {
        guard image != nil else {
            self.animatedImage = nil
            self.image = nil
            return
        }
        if let image = image as? AnimatedImage {
            // Display poster image immediately
            self.image = image

            // Start playback after we prefare FLAnimatedImage for rendering
            DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async {
                let animatedImage = FLAnimatedImage(animatedGIFData: image.data)
                DispatchQueue.main.async {
                    if self.image === image { // Still displaying the same poster image
                        self.animatedImage = animatedImage
                    }
                }
            }
        } else {
            self.image = image
        }
    }
}

/// Prevents `ImageLoader` from processing animated images.
public class AnimatedImageLoaderDelegate: ImageLoaderDefaultDelegate {
    /// Disabled processing of animated images.
    public override func loader(_ loader: ImageLoader, processorFor request: ImageRequest, image: Image) -> ImageProcessing? {
        return image is AnimatedImage ? nil : super.loader(loader, processorFor: request, image: image)
    }
}

/// Memory cache that is aware of animated images. Can be used for both single-frame and animated images.
public class AnimatedImageMemoryCache: ImageMemoryCache {

    /// Can be used to disable storing animated images. Default value is true (storage is allowed).
    public var allowsAnimatedImagesStorage = true

    /// Stores response unless the image is an instance of AnimatedImage class and animated image storage is disabled.
    public override func setResponse(_ response: ImageCachedResponse, forKey key: ImageRequestKey) {
        if !self.allowsAnimatedImagesStorage && response.image is AnimatedImage {
            return
        }
        super.setResponse(response, forKey: key)
    }

    /// Returns cost for a given image.
    public override func costFor(_ image: Image) -> Int {
        if let animatedImage = image as? AnimatedImage {
            return animatedImage.data.count + super.costFor(image)
        }
        return super.costFor(image)
    }
}
