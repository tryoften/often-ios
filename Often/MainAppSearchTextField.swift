//
//  MainAppSearchTextField.swift
//  Often
//
//  Created by Kervins Valcourt on 12/22/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class MainAppSearchTextField: UITextField, SearchTextField {
    private var searchIcon: UIImageView

    override var text: String? {
        didSet {
            if text == "" {
                placeholder = SearchBarPlaceholderText
            }
        }
    }

    override var selected: Bool {
        didSet {
            sizeToFit()

            if selected {
                becomeFirstResponder()

                self.searchIcon.image = StyleKit.imageOfSearchbaricon(color: UIColor(fromHexString: "#BEBEBE"), scale: 1.0)
                layer.borderColor = UIColor.clearColor().CGColor

                if !editing {
                    sendActionsForControlEvents(UIControlEvents.EditingDidBegin)
                }

                layer.borderColor = UIColor.clearColor().CGColor
                textAlignment = .Left

            } else {
                if editing {
                    sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
                }

                if text == "" && placeholder != nil {
                    placeholder = SearchBarPlaceholderText
                    self.searchIcon.image = StyleKit.imageOfSearchbaricon(color: LightBlackColor, scale: 1.0)
                }

                if self.text == "" {
                    self.textColor = LightBlackColor
                    layer.borderColor = UIColor(fromHexString: "#E3E3E3").CGColor

                } else {
                   layer.borderColor = UIColor.clearColor().CGColor
                }

                backgroundColor = VeryLightGray
                textAlignment = .Center
            }
        }
    }

    override required init(frame: CGRect) {
        searchIcon = UIImageView(image: StyleKit.imageOfSearchbaricon(color: LightBlackColor, scale: 1.0))
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.contentMode = .ScaleAspectFit

        super.init(frame: frame)
        text = ""
        font = UIFont(name: "OpenSans-Semibold", size: 12)

        clearButtonMode = .WhileEditing
        contentHorizontalAlignment = .Center
        textAlignment = .Center

        backgroundColor = VeryLightGray

        setupLayout()

        textColor = UIColor.blackColor()
    }

    convenience init() {
        self.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func resignFirstResponder() -> Bool {
        selected = false
        return super.resignFirstResponder()
    }

    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !selected {
            selected = true
        }
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width, bounds.size.height)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }
    
    func reset() {
        clear()
        selected = false

        sendActionsForControlEvents(.EditingDidEnd)
        sendActionsForControlEvents(.EditingDidEndOnExit)
    }

    func clear() {
        text = ""
        placeholder = SearchBarPlaceholderText
    }

}