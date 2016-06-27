//
//  MockURLSessionDataTask.swift
//  Nuke
//
//  Created by Alexander Grebenyuk on 3/14/15.
//  Copyright (c) 2016 Alexander Grebenyuk (github.com/kean). All rights reserved.
//

import Foundation

let MockURLSessionDataTaskDidResumeNotification = "didResume"
let MockURLSessionDataTaskDidCancelNotification = "didCancel"

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
        NotificationCenter.default().post(name: Notification.Name(rawValue: MockURLSessionDataTaskDidResumeNotification), object: self)
    }
    override func cancel() {
        NotificationCenter.default().post(name: Notification.Name(rawValue: MockURLSessionDataTaskDidCancelNotification), object: self)
    }
}
