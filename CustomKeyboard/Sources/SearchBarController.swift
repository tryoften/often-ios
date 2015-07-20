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
    var searchTapGestureRecognizer: UITapGestureRecognizer!
    var textProcessor: TextProcessingManager?
    var activeServiceProviderType: ServiceProviderType? {
        didSet {
            switch(activeServiceProviderType!) {
            case .Venmo:
                activeServiceProvider = VenmoServiceProvider(providerType: activeServiceProviderType!)
                let button = activeServiceProvider!.provideSearchBarButton()
                searchBarView.textInput.leftView = button
                UIView.animateWithDuration(0.3) {
                    self.searchBarView.textInput.layoutIfNeeded()
                }
                break
            case .Foursquare:
                break
            default:
                break
            }
        }
    }
    private var activeServiceProvider: ServiceProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapSearchBar:")
        searchBarView.addGestureRecognizer(searchTapGestureRecognizer)
        searchBarView.textInput.delegate = self
        searchBarView.textInput.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        view = SearchBar()
        searchBarView = view as! SearchBar
    }
    
    func didTapSearchBar(gestureRecogniser: UIGestureRecognizer) {
        var point = gestureRecogniser.locationInView(searchBarView)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            if touch.view == searchBarView {
                searchBarView.textInput.resignFirstResponder()
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        searchBarView.textInput.inputDelegate = textProcessor
    }
    
    func textFieldDidChange() {
        textProcessor?.textDidChange(searchBarView.textInput)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}
