//
//  StandardKeyboardViewController.swift
//  Drizzy
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class StandardKeyboardViewController: UIViewController, TextProcessingManagerDelegate {
    let locale: Language = .English
    var textProcessor: TextProcessingManager!
    var keysContainerView: TouchRecognizerView!
    var searchBar: SearchBarController!
    var lettercase: Lettercase!
    var layout: KeyboardLayout
    private var layoutView: KeyboardLayoutView
    
    init(textProcessor: TextProcessingManager) {
        self.textProcessor = textProcessor

        searchBar = SearchBarController(nibName: nil, bundle: nil)
        searchBar.textProcessor = textProcessor
        searchBar.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        keysContainerView = TouchRecognizerView()
        keysContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        keysContainerView.backgroundColor = UIColor(fromHexString: "#202020")
        
        if let defaultLayout = KeyboardLayouts[locale] {
            layout = defaultLayout
        } else {
            layout = DefaultKeyboardLayout
        }
        
        layoutView = KeyboardLayoutView(layout: layout)
        layoutView.setTranslatesAutoresizingMaskIntoConstraints(false)
        keysContainerView.addSubview(layoutView)
        
        lettercase = .Lowercase

        super.init(nibName: nil, bundle: nil)
        
        textProcessor.delegate = self
        view.addSubview(searchBar.view)
        view.addSubview(keysContainerView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func setupLayout() {
        view.addConstraints([
            searchBar.view.al_top == view.al_top,
            searchBar.view.al_left == view.al_left,
            searchBar.view.al_right == view.al_right,
            {
                let constraint =  self.keysContainerView.al_top == self.searchBar.view.al_bottom
                constraint.priority = 999
                return constraint
                }(),
            {
                let constraint = self.keysContainerView.al_height == 215
                constraint.priority = 800
                return constraint
                }(),
            keysContainerView.al_bottom == view.al_bottom,
            keysContainerView.al_left == view.al_left,
            keysContainerView.al_right == view.al_right,
            
            layoutView.al_top == keysContainerView.al_top,
            layoutView.al_bottom == keysContainerView.al_bottom,
            layoutView.al_left == keysContainerView.al_left,
            layoutView.al_right == keysContainerView.al_right
        ])
        
        var keys = layoutView.allKeys
        for key in keys {
            key.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
            key.addTarget(self, action: "didTouchDownOnKey:", forControlEvents: .TouchDown)
//            key.addTarget(self, action: "backspaceUp:", forControlEvents: .TouchDragExit | .TouchUpOutside | .TouchCancel | .TouchDragOutside)
        }
        keysContainerView.keys = keys
    }

    func didTapButton(sender: AnyObject?) {
        
        let button = sender as! KeyboardKeyButton
        
        button.highlighted = false
        button.selected = !button.selected

        switch(button.key) {
        case .letter(let character):
            var str = String(character.rawValue)
            if lettercase! == .Lowercase {
                str = str.lowercaseString
            }
            textProcessor.insertText(str)
        case .digit(let number):
            textProcessor.insertText(String(number.rawValue))
        case .special(let character):
            textProcessor.insertText(String(character.rawValue))
        case .modifier(.CapsLock):
            lettercase = (lettercase == .Lowercase) ? .Uppercase : .Lowercase
            
            for keyButton in layoutView.allKeys {
                keyButton.lettercase = lettercase
            }
        case .modifier(.SwitchKeyboard):
            NSNotificationCenter.defaultCenter().postNotificationName("switchKeyboard", object: nil)
        case .modifier(.Backspace):
            textProcessor.deleteBackward()
        case .modifier(.AlphabeticKeypad):
            layoutView.setActivePageViewWithIdentifier(.Letter)
        case .modifier(.SpecialKeypad):
            layoutView.setActivePageViewWithIdentifier(.Special)
        case .modifier(.NextSpecialKeypad):
            layoutView.setActivePageViewWithIdentifier(.SecondSpecial)
        case .modifier(.Space):
            textProcessor.insertText(" ")
        case .modifier(.Enter):
            textProcessor.insertText("\n")
        case .modifier(.GoToBrowse):
            dismissViewControllerAnimated(false, completion: nil)
        default:
            break
        }
    }
    
    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
    }
    
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType) {
        searchBar.activeServiceProviderType = serviceProviderType
    }
    
    func didTouchDownOnKey(sender: AnyObject?) {
        let button = sender as! KeyboardKeyButton
        
        button.highlighted = true
        
        switch(button.key) {
        case .modifier(.Backspace):
            textProcessor.deleteBackward()
        default:
            break
        }
    }
}

