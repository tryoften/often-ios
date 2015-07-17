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

class KeyboardViewController: UIInputViewController,
    TextProcessingManagerDelegate {

    var heightConstraint: NSLayoutConstraint!
    var viewModel: KeyboardViewModel
    var seperatorView: UIView!
    var textProcessor: TextProcessingManager!
    var standardKeyboardVC: StandardKeyboardViewController
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
        view.addSubview(standardKeyboardVC.view)
        view.addSubview(seperatorView)
 
        view.backgroundColor = UIColor.whiteColor()
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(debug: Bool = false) {
        KeyboardViewController.debugKeyboard = debug
        self.init(nibName: nil, bundle: nil)
    }
    
    deinit {
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: KeyboardHeight)
        heightConstraint.priority = 1000
        
        view.addConstraint(heightConstraint)
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    func bootstrap() {
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        Flurry.startSession(FlurryClientKey)
    }
    
    func switchKeyboard() {
        dismissKeyboard()
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("received memory warning")
    }

    func setupLayout() {
        if let standardKeyboardView = standardKeyboardVC.view {
            var constraints: [NSLayoutConstraint] = [
                
//                seperatorView.al_height == 1.0,
//                seperatorView.al_width == view.al_width,
//                seperatorView.al_top == view.al_top,
//                seperatorView.al_left == view.al_left,
                
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
    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
        if let lyric = textProcessingManager.currentlyInjectedLyric {
        }
    }
}


