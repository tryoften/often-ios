//
//  KeyboardViewController.swift
//  Surf
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Surf. All rights reserved.
//
//  swiftlint:disable variable_name

let ShiftStateUserDefaultsKey = "kShiftState"
let SwitchKeyboardEvent = "switchKeyboard"
let CollapseKeyboardEvent = "collapseKeyboard"
let RestoreKeyboardEvent = "restoreKeyboard"
let ToggleButtonKeyboardEvent = "toggleButtonKeyboard"

class KeyboardContainerViewController: UIViewController {
    var keyboard: KeyboardViewController

    init(textProcessor: TextProcessingManager) {
        keyboard = KeyboardViewController(textProcessor: textProcessor)

        super.init(nibName: nil, bundle: nil)

        view.addSubview(keyboard.view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        keyboard.view.frame = view.bounds
    }
}