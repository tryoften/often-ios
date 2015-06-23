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
    var sessionManager: SessionManager!
    var navButton: UIBarButtonItem!
    var nextButton: UIButton!
    var bottomConstraint: NSLayoutConstraint!
    
    init (sessionManager: SessionManager = SessionManager.defaultManager) {
        self.sessionManager = sessionManager
        viewModel = SignUpWalkthroughViewModel(sessionManager: sessionManager)
        
        nextButton = UIButton()
        nextButton.hidden = true
        nextButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextButton.titleLabel!.font = ButtonFont
        nextButton.backgroundColor = UIColor(fromHexString: "#2CD2B4")
        nextButton.setTitle("continue".uppercaseString, forState: .Normal)
        
        super.init(nibName: nil, bundle: nil)
        
        nextButton.addTarget(self, action: "didTapNavButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(nextButton)
        bottomConstraint = nextButton.al_bottom == view.al_bottom
    }
    
    init (viewModel:SignUpWalkthroughViewModel) {
        self.viewModel = viewModel
        
        nextButton = UIButton()
        nextButton.hidden = true
        nextButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextButton.titleLabel!.font = ButtonFont
        nextButton.backgroundColor = UIColor(fromHexString: "#2CD2B4")
        nextButton.setTitle("continue".uppercaseString, forState: .Normal)
        
        super.init(nibName: nil, bundle: nil)
        
        nextButton.addTarget(self, action: "didTapNavButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(nextButton)
        bottomConstraint = nextButton.al_bottom == view.al_bottom
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        
        self.an_subscribeKeyboardWithAnimations({ (keyboardRect, duration, isShowing) in
            self.bottomConstraint.constant = isShowing ? -keyboardRect.size.height : 0
            UIView.transitionWithView(self.nextButton, duration: 6.0, options: .CurveEaseIn, animations: { () -> Void in
                
            }, completion: { finished in
                
            })
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

    func setupNavBar(titlePushViewButton: String) {
        navButton = UIBarButtonItem(title: titlePushViewButton.uppercaseString, style: .Plain, target: self, action: "didTapNavButton")
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        let backButton = UIButton(frame: CGRectMake(0, 0, 20, 16))
        let backImage = UIImage(named: "BackButton")
        let backButtonItem = UIBarButtonItem(customView: backButton)
        let textAttributes = [NSFontAttributeName:ButtonFont!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        let textAttributeForButtons = [NSFontAttributeName:ButtonFont!, NSForegroundColorAttributeName: UIColor(fromHexString: "#FFFFFF")]
        
        fixedSpaceItem.width = 10
        
        backButton.setBackgroundImage(backImage, forState: .Normal)
        backButton.imageView?.contentMode = .ScaleAspectFit
        backButton.addTarget(self, action: "popBack", forControlEvents: .TouchUpInside)
        
        navButton.setTitleTextAttributes(textAttributeForButtons, forState: .Normal)
        
        navigationItem.rightBarButtonItems = [fixedSpaceItem,navButton]
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "sign up".uppercaseString
        navigationItem.rightBarButtonItem?.tintColor = BlackColor
    }
    
    func setupLayout() {

        view.addConstraints([
            nextButton.al_width == view.al_width,
            nextButton.al_left == view.al_left,
            nextButton.al_height == 50,
            bottomConstraint
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
}
