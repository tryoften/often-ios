//
//  EventEmittable.swift
//  Often
//
//  Created by Luc Succes on 12/16/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

/**
    Protocol that defines a set of events that can top
    ```
    class Foo: EventEmittable {
        enum Events: Event<AnyObject> {
            case textEdited
        }
        var events: [Events] = [.textEdited]
    }
    ```
*/
protocol EventEmittable {
    var events: [Event<AnyObject>] { get set }
}