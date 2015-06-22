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
    var sessionManager: SessionManager
    var navButton : UIBarButtonItem!
    
    init (sessionManager: SessionManager = SessionManager.defaultManager) {
        self.sessionManager = sessionManager
        viewModel = SignUpWalkthroughViewModel(sessionManager: sessionManager)
        
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setupLayout()
    }
    
    func didTapNavButton() {}
    func setupLayout() {}
    
    func setupNavBar(titlePushViewButton: String) {
        navButton = UIBarButtonItem(title: titlePushViewButton.uppercaseString, style: .Plain, target: self, action: "didTapNavButton")
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        let backButton = UIButton(frame: CGRectMake(0, 0, 20, 16))
        let backImage = UIImage(named: "BackButton")
        let backButtonItem = UIBarButtonItem(customView: backButton)
        let textAttributes = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: UIColor.whiteColor()]
        let textAttributeForButtons = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: UIColor(fromHexString: "#FFFFFF")]
        
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
    
    func popBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        didTapNavButton()
        
        return true
    }
}
