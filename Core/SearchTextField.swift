//
//  SearchTextField.swift
//  Often
//
//  Created by Luc Succes on 12/22/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

protocol SearchTextField {
    init(frame: CGRect)

    var frame: CGRect { get set }

    // text displayed in text field
    var text: String? { get set }

    // whether the text field is selected (active) or not
    var selected: Bool { get set }

    // sets the placeholder text back on the text field and clears the current text
    func clear()

    // reset clears the text and brings back text field to it's original state
    func reset()

    // add target/action for particular event. you can call this multiple times and you can specify multiple target/actions for a particular event.
    // passing in nil as the target goes up the responder chain. The action may optionally include the sender and the event in that order
    // the action cannot be NULL. Note that the target is not retained.
    func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)

    // remove the target/action for a set of events. pass in NULL for the action to remove all actions for that target
    func removeTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents)

    func becomeFirstResponder() -> Bool
    func resignFirstResponder() -> Bool
}