//
//  XCTestCase+Nuke.swift
//  Nuke
//
//  Created by Alexander Grebenyuk on 01/10/15.
//  Copyright (c) 2016 Alexander Grebenyuk. All rights reserved.
//

import XCTest
import Foundation

extension XCTestCase {
    public func expect(_ block: (fulfill: (Void) -> Void) -> Void) {
        let expectation = self.expectation()
        block(fulfill: { expectation.fulfill() })
    }

    public func expectation() -> XCTestExpectation {
        return self.expectation(withDescription: "GenericExpectation")
    }

    public func expectNotification(_ name: String, object: AnyObject? = nil, handler: XCNotificationExpectationHandler? = nil) -> XCTestExpectation {
        return self.expectation(forNotification: name, object: object, handler: handler)
    }

    public func wait(_ timeout: TimeInterval = 2.0, handler: XCWaitCompletionHandler? = nil) {
        self.waitForExpectations(withTimeout: timeout, handler: handler)
    }
}
