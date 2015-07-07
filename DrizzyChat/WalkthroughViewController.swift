//
//  ViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate,
    WalkthroughViewModelDelegate {
    var viewModel: SignUpWalkthroughViewModel
    var navButton: UIBarButtonItem!
    var nextButton: UIButton
    var bottomConstraint: NSLayoutConstraint!
    var didAnimateUp = true
    var hideButton = false
    var errorView: ErrorMessageView
    
    init (viewModel: SignUpWalkthroughViewModel) {
        self.viewModel = viewModel
        
        nextButton = UIButton()
        self.nextButton.hidden = true
        nextButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextButton.titleLabel!.font = ButtonFont
        nextButton.backgroundColor = UIColor(fromHexString: "#2CD2B4")
        nextButton.setTitle("continue".uppercaseString, forState: .Normal)
        
        errorView = ErrorMessageView()
        errorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        errorView.hidden = true


        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
        nextButton.addTarget(self, action: "didTapNavButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(nextButton)
        view.addSubview(errorView)
        
        bottomConstraint = nextButton.al_bottom == view.al_bottom + 50
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
    }
    
    deinit {
        viewModel.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        
        self.an_subscribeKeyboardWithAnimations({ (keyboardRect, duration, isShowing) in
            self.bottomConstraint.constant = (isShowing ? -CGRectGetHeight(keyboardRect) : 0) + 50
        }, completion: { finished in
            
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)        
        self.an_unsubscribeKeyboard()
    }
    
    func didTapNavButton() {}
    
    func setupBackButton() {
        let backButton = UIButton(frame: CGRectMake(0, 0, 20, 16))
        let backImage = UIImage(named: "BackButton")
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        backButton.setBackgroundImage(backImage, forState: .Normal)
        backButton.imageView?.contentMode = .ScaleAspectFit
        backButton.addTarget(self, action: "popBack", forControlEvents: .TouchUpInside)
        
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "sign up".uppercaseString
    }
    
    func errorFound() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            self.errorView.hidden = false
            self.errorView.frame.origin.y += 50
            
            }, completion: {
                (finished: Bool) in
                UIView.animateWithDuration(0.3, delay: 5.0, options: .CurveLinear, animations: {
                    
                    self.errorView.frame.origin.y -= 50
                    
                    }, completion: {
                        (finished: Bool) in
                        self.errorView.hidden = true
                })
        })
        
    }
    
    func setupLayout() {
        view.addConstraints([
            nextButton.al_width == view.al_width,
            nextButton.al_left == view.al_left,
            nextButton.al_height == 50,
            bottomConstraint,
            
            errorView.al_width == view.al_width,
            errorView.al_left == view.al_left,
            errorView.al_height == 40,
            errorView.al_top == view.al_top - 50
        ])
    }
    
    func popBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        didTapNavButton()
        
        return true
    }
    
    func walkthroughViewModelDidLoginUser(walkthroughViewModel: SignUpWalkthroughViewModel, user: User, isNewUser: Bool) {
        var presentedViewController: UIViewController
        if isNewUser {
            presentedViewController = SignUpPreAddArtistsLoaderViewController(viewModel: viewModel)
            navigationController?.pushViewController(presentedViewController, animated: true)
        } else {
            presentedViewController = TabBarController()
            self.presentViewController(presentedViewController, animated: true, completion: nil)
            
            // Need to call this in order to prevent this method from getting called again
            viewModel.delegate = nil
        }
    }
}
