//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import Realm
import Fabric
import Crashlytics

class KeyboardViewController: UIInputViewController, UIInputViewAudioFeedback {

    var heightConstraint: NSLayoutConstraint!
    var viewModel: KeyboardViewModel
    var seperatorView: UIView!
    var textProcessor: TextProcessingManager!
    var standardKeyboardVC: StandardKeyboardViewController
    var enableInputClicksWhenVisible: Bool {
        return true
    }
    static var debugKeyboard = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        viewModel = KeyboardViewModel.sharedInstance
        standardKeyboardVC = StandardKeyboardViewController()
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy as! UITextDocumentProxy)
        standardKeyboardVC.textProcessor = textProcessor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchKeyboard", name: "switchKeyboard", object: nil)

        standardKeyboardVC.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        inputView.addSubview(standardKeyboardVC.view)
        inputView.addSubview(seperatorView)
        inputView.backgroundColor = UIColor.whiteColor()
        
        if KeyboardViewController.debugKeyboard {
            var viewFrame = view.frame
            viewFrame.size.height = KeyboardHeight
            view.frame = viewFrame
        } else {
            inputView.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(debug: Bool = false) {
        KeyboardViewController.debugKeyboard = debug
        self.init(nibName: nil, bundle: nil)
    }

    override func updateViewConstraints() {
        if let heightConstraint = heightConstraint {
            heightConstraint.constant = KeyboardHeight
        }
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        heightConstraint = inputView.al_height == KeyboardHeight
        heightConstraint.priority = 1000
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        
        inputView.addConstraints([
            inputView.al_width == screenWidth,
            heightConstraint
        ])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bootstrap() {
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        Flurry.startSession(FlurryClientKey)
    }
    
    func switchKeyboard() {
        advanceToNextInputMode()
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupLayout() {
        if let standardKeyboardView = standardKeyboardVC.view {
            var constraints: [NSLayoutConstraint] = [
                seperatorView.al_height == 1.0,
                seperatorView.al_width == view.al_width,
                seperatorView.al_top == view.al_top,
                seperatorView.al_left == view.al_left,
                
                // Lyric Picker
                standardKeyboardView.al_top == view.al_top,
                standardKeyboardView.al_left == view.al_left,
                standardKeyboardView.al_right == view.al_right,
                standardKeyboardView.al_bottom == view.al_bottom
            ]
            view.addConstraints(constraints)
        }
    }
    
    override func textWillChange(textInput: UITextInput) {
        textProcessor.textWillChange(textInput)
    }
    
    override func textDidChange(textInput: UITextInput) {
        textProcessor.textDidChange(textInput)
    }

    override func selectionWillChange(textInput: UITextInput) {
        textProcessor.selectionWillChange(textInput)
    }
    
    override func selectionDidChange(textInput: UITextInput) {
        textProcessor.selectionDidChange(textInput)
    }

}


