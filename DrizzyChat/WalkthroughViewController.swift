//
//  ViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    var viewModel: SignUpWalkthroughViewModel!
    var artistService: ArtistService!
    let firebaseRoot = Firebase(url: BaseURL)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistService = ArtistService(root: firebaseRoot)
    }
    
    override func viewWillAppear(animated: Bool) {
        setupLayout()
    }
    
    func setupNavBar (titlePushViewButton: String) {
        let navButton = UIBarButtonItem(title: titlePushViewButton.uppercaseString, style: .Plain, target: self, action: "didTapNavButton")
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
        
        navigationController?.navigationBar.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.size.width, 54))
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = BlackColor
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func didTapNavButton() {}
    func setupLayout() {}
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func popBack() {
        navigationController?.popViewControllerAnimated(true)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        didTapNavButton()
        
        return true
    }
}
