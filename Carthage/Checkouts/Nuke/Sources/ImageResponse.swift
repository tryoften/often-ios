// The MIT License (MIT)
//
// Copyright (c) 2016 Alexander Grebenyuk (github.com/kean).

import Foundation

/// Represents image response.
public enum ImageResponse {
    /// Task completed successfully.
    case success(Image, ImageResponseInfo)

    /// Task either failed or was cancelled. See ImageManagerErrorDomain for more info.
    case failure(ErrorProtocol)
}

/// Convenience methods to access associated values.
public extension ImageResponse {
    /// Returns image if the response was successful.
    public var image: Image? {
        switch self {
        case .success(let image, _): return image
        case .failure(_): return nil
        }
    }

    /// Returns error if the response failed.
    public var error: ErrorProtocol? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }

    /// Returns true if the response was successful.
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    // FIXME: Should ImageResponse contain a `fastResponse` property?
    internal func makeFastResponse() -> ImageResponse {
        switch self {
        case .success(let image, var info):
            info.isFastResponse = true
            return ImageResponse.success(image, info)
        case .failure: return self
        }
    }
}

/// Metadata associated with the image response.
public struct ImageResponseInfo {
    /// Returns true if the image was retrieved from memory cache.
    public var isFastResponse: Bool
    
    /// User info returned by the image loader (see ImageLoading protocol).
    public var userInfo: Any?
}
