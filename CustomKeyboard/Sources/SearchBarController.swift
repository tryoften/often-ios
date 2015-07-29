//
//  SearchBarController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class SearchBarController: UIViewController, UITextFieldDelegate {
    var searchBarView: SearchBar!
    var supplementaryViewContainer: UIView!
    var supplementaryViewHeightConstraint: NSLayoutConstraint!
    var textProcessor: TextProcessingManager? {
        didSet {
            primaryTextDocumentProxy = textProcessor?.currentProxy
        }
    }

    var primaryTextDocumentProxy: UITextDocumentProxy?
    var activeServiceProviderType: ServiceProviderType? {
        didSet {
            var button: ServiceProviderSearchBarButton?
            switch(activeServiceProviderType!) {
            case .Venmo:
                activeServiceProvider = VenmoServiceProvider(providerType: activeServiceProviderType!, textProcessor: textProcessor!)
                activeServiceProvider?.searchBarController = self
                button = activeServiceProvider!.provideSearchBarButton()
                break
            case .Foursquare:
                break
            default:
                break
            }
            searchBarView.providerButton = button
        }
    }

    var activeServiceProvider: ServiceProvider? {
        didSet {
            if let supplementaryViewController = activeServiceProvider?.provideSupplementaryViewController() {
                supplementaryViewController.searchBarController = self
                activeSupplementaryViewController = supplementaryViewController
                supplementaryViewContainer.addSubview(supplementaryViewController.view)

                NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
                    "height": KeyboardHeight + supplementaryViewController.supplementaryViewHeight
                ])
            }
        }
    }
    var activeSupplementaryViewController: ServiceProviderSupplementaryViewController? {
        didSet {
            if let supplementaryViewController = activeSupplementaryViewController {
                supplementaryViewHeightConstraint.constant = supplementaryViewController.supplementaryViewHeight
                
                searchBarView.textInput.placeholder = supplementaryViewController.searchBarPlaceholderText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarView = SearchBar()
        searchBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchBarView.textInput.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        searchBarView.textInput.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: .EditingDidBegin)
        searchBarView.textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
        if let textProcessor = textProcessor {
            textProcessor.proxies["search"] = searchBarView.textInput
        }
        
        supplementaryViewContainer = UIView()
        supplementaryViewContainer.backgroundColor = VeryLightGray
        supplementaryViewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        supplementaryViewHeightConstraint = supplementaryViewContainer.al_height == 0
        
        view.addSubview(searchBarView)
        view.addSubview(supplementaryViewContainer)
        view.addConstraints([
            searchBarView.al_top == view.al_top,
            searchBarView.al_width == view.al_width,
            searchBarView.al_left == view.al_left,
            searchBarView.al_height == 40,

            supplementaryViewContainer.al_top == searchBarView.al_bottom,
            supplementaryViewContainer.al_bottom == view.al_bottom,
            supplementaryViewContainer.al_left == view.al_left,
            supplementaryViewContainer.al_width == view.al_width,
            supplementaryViewHeightConstraint
        ])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveSearchBarButton:", name: VenmoAddSearchBarButtonEvent, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            if touch.view == searchBarView {
                searchBarView.textInput.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let activeSupplementaryViewController = activeSupplementaryViewController {
            activeSupplementaryViewController.view.frame = supplementaryViewContainer.bounds
        }
    }
    
    func didReceiveSearchBarButton(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            button = userInfo["button"] as? SearchBarButton {
            searchBarView.addButton(button)
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textProcessor?.setCurrentProxyWithId("search")
    }
    
    func textFieldDidChange() {
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textProcessor?.setCurrentProxyWithId("default")
    }
}
