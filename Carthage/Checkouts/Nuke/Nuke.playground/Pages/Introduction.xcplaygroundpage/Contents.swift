import Nuke
import UIKit
import XCPlayground

/*:
## Why use Nuke?

Nuke is an advanced pure Swift framework for loading, caching, processing, displaying and preheating images. It takes care of all those things so you don't have to. 

Nuke's goal is to solve those complex tasks in a most efficient and user-friendly manner. Without compromising on extensibility.
*/

/*:
### Zero Config
Create and resume `ImageTask` with `NSURL`.
*/
Nuke.taskWith(NSURL(string: "https://farm8.staticflickr.com/7315/16455839655_7d6deb1ebf_z_d.jpg")!) {
    let image = $0.image
}.resume()

/*:
### Adding Request Options
Create `ImageRequest` with `NSURLRequest`. Configure `ImageRequest` to resize image. Create and resume `ImageTask`.
*/

let URLRequest = NSURLRequest(URL: NSURL(string: "https://farm4.staticflickr.com/3892/14940786229_5b2b48e96c_z_d.jpg")!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 60)
var request = ImageRequest(URLRequest: URLRequest)

// Set target size in pixels
request.targetSize = CGSize(width: 200.0, height: 200.0)
request.contentMode = .AspectFill

Nuke.taskWith(request) {
    let image = $0.image
}.resume()

/*:
### Using Image Response
`ImageResponse` is an enum with associated values. If the request is successful `ImageResponse` contains image and response metadata. If request fails `ImageResponse` contains an error.
*/

Nuke.taskWith(NSURL(string: "https://farm8.staticflickr.com/7315/16455839655_7d6deb1ebf_z_d.jpg")!) { response in
    switch response {
    case let .Success(image, info):
        if info.isFastResponse {
            // Image was retrieved synchronously from memory cache
        }
        let image = image
    case let .Failure(error):
        // Handle error
        break
    }
}.resume()

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: [Next](@next)
