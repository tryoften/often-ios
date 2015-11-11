//
//  AutocorrectSuggestionsViewController.swift
//  Often
//
//  Created by Luc Succes on 11/8/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

let AutocorrectSuggestionTapEvent = "AutocorrectSuggestions.didTapSuggestion"

class AutocorrectSuggestionsViewController: UIViewController {
    private var suggestionViews: [AutocorrectSuggestionView]
    private var hideTimer: NSTimer?
    
    weak var delegate: AutocorrectSuggestionsViewControllerDelegate?
    
    var suggestions: [SuggestItem]? {
        didSet {
            if let timer = hideTimer {
                timer.invalidate()
            }
            
            guard let suggestions = suggestions else {
                view.hidden = true
                return
            }
            
            if suggestions.isEmpty {
                view.hidden = true
                return
            }
            
            guard let delegate = delegate else {
                renderSuggestions()
                startHideSuggestionsTimer()
                return
            }

            if delegate.autocorrectSuggestionsViewControllerShouldShowSuggestions(self) {
                renderSuggestions()
                startHideSuggestionsTimer()
            }
        }
    }
    
    init() {
        suggestionViews = [AutocorrectSuggestionView]()
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = DefaultTheme.keyboardBackgroundColor
        view.hidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startHideSuggestionsTimer() {
        hideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "hideSuggestionsFired", userInfo: nil, repeats: false)
    }
    
    func hideSuggestionsFired() {
        view.hidden = true
    }
    
    func renderSuggestions() {
        for suggestionView in suggestionViews {
            suggestionView.removeFromSuperview()
        }
        suggestionViews.removeAll()
        
        guard let suggestions = suggestions else {
            return
        }
        
        var previousView: AutocorrectSuggestionView?
        var constraints = [NSLayoutConstraint]()
        
        for suggestion in suggestions {
            let suggestionView = AutocorrectSuggestionView(suggestion: suggestion)
            suggestionView.addTarget(self, action: "didTapSuggestion:", forControlEvents: .TouchUpInside)

            suggestionViews.append(suggestionView)
            view.addSubview(suggestionView)
            
            constraints += [
                suggestionView.al_top == view.al_top + 5,
                suggestionView.al_bottom == view.al_bottom - 5
            ]
            
            if previousView == nil {
                constraints += [suggestionView.al_left == view.al_left + 5]
            } else {
                constraints += [suggestionView.al_left == previousView!.al_right + 5]
            }
            
            constraints += [suggestionView.al_width == (view.al_width / CGFloat(suggestions.count)) - 10]
            previousView = suggestionView
        }

        view.addConstraints(constraints)
        view.hidden = false
    }
    
    func didTapSuggestion(target: AutocorrectSuggestionView?) {
        guard let button = target else {
            return
        }
        
        delegate?.autocorrectSuggestionsViewControllerDidSelectSuggestion(self, suggestion: button.suggestion)
        NSNotificationCenter.defaultCenter().postNotificationName(AutocorrectSuggestionTapEvent, object: button)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

protocol AutocorrectSuggestionsViewControllerDelegate: class {
    func autocorrectSuggestionsViewControllerDidSelectSuggestion(autocorrectSuggestions: AutocorrectSuggestionsViewController, suggestion: SuggestItem)
    func autocorrectSuggestionsViewControllerShouldShowSuggestions(autocorrectSuggestions: AutocorrectSuggestionsViewController) -> Bool
}
