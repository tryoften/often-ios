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

let ResizeKeyboardEvent = "resizeKeyboard"
let SwitchKeyboardEvent = "switchKeyboard"

class KeyboardViewController: UIInputViewController, UIInputViewAudioFeedback {

    var heightConstraint: NSLayoutConstraint!
    var viewModel: KeyboardViewModel
    var seperatorView: UIView!
    var textProcessor: TextProcessingManager!
    var standardKeyboardVC: StandardKeyboardViewController
    var enableInputClicksWhenVisible: Bool {
        return true
    }
    var kludge: UIView?
    static var debugKeyboard = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        viewModel = KeyboardViewModel.sharedInstance
        standardKeyboardVC = StandardKeyboardViewController()
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        addChildViewController(standardKeyboardVC)
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy as! UITextDocumentProxy)
        standardKeyboardVC.textProcessor = textProcessor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchKeyboard", name: SwitchKeyboardEvent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resizeKeyboard:", name: ResizeKeyboardEvent, object: nil)

        standardKeyboardVC.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        inputView.addSubview(standardKeyboardVC.view)
        inputView.addSubview(seperatorView)
        inputView.backgroundColor = UIColor.whiteColor()
        
        if KeyboardViewController.debugKeyboard {
            var viewFrame = view.frame
            viewFrame.origin.y = 0
            viewFrame.size.height = KeyboardHeight
            view.frame = viewFrame
        } else {
//            view.setTranslatesAutoresizingMaskIntoConstraints(false)
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
        
        inputView.addConstraints([
            heightConstraint
        ])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupKludge()
    }
    
    func bootstrap() {
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        Flurry.startSession(FlurryClientKey)
    }
    
    func switchKeyboard() {
        advanceToNextInputMode()
    }
    
    func resizeKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            height = userInfo["height"] as? CGFloat {
            heightConstraint.constant = height
//            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
//            }
        }
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
    
    // without this here kludge, the height constraint for the keyboard does not work for some reason
    func setupKludge() {
        if self.kludge == nil {
            var kludge = UIView()
            self.view.addSubview(kludge)
            kludge.setTranslatesAutoresizingMaskIntoConstraints(false)
            kludge.hidden = true
            
            let a = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let b = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let c = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let d = NSLayoutConstraint(item: kludge, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            self.view.addConstraints([a, b, c, d])
            
            self.kludge = kludge
        }
    }

}


