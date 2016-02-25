//
//  SearchBar.swift
//  Often
//
//  Created by Luc Succes on 12/22/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
/**
 *  Protocol that defines a set of events need for SearchBar
 */

protocol SearchBar {
    init(frame: CGRect)

    var frame: CGRect { get set }

    // text displayed in text field
    var text: String? { get set }

    // whether the text field is selected (active) or not
    var selected: Bool { get set }

    weak var delegate: UISearchBarDelegate? { get set }

    // reset clears the text and brings back text field to it's original state
    func reset()

    // sets the placeholder text back on the text field and clears the current text
    func clear()

    func becomeFirstResponder() -> Bool

    func resignFirstResponder() -> Bool
}