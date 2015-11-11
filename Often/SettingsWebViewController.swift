//
//  SettingsWebViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 10/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SettingsWebViewController: UIViewController {
    var navigationBar: UIView
    var closeButton: UIButton
    var webView: UIWebView
    var titleBar: UILabel
    
    init(title: String, website: String) {
        navigationBar = UIView()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = SettingsTableViewControllerNavBarBackgroundColor
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close-white"), forState: UIControlState.Normal)
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)
        
        titleBar = UILabel()
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.font = UIFont(name: "OpenSans", size: 18)
        titleBar.text = title.uppercaseString
        titleBar.backgroundColor = UIColor.clearColor()
        titleBar.numberOfLines = 0
        titleBar.textAlignment = .Center
        titleBar.textColor = WhiteColor
        
        
        let requestURL = NSURL(string: website)
        let request = NSURLRequest(URL: requestURL!)
        
        webView = UIWebView(frame: CGRectMake(0, 50, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webView.loadRequest(request)
        
        super.init(nibName: nil, bundle: nil)
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(webView)
        view.addSubview(navigationBar)
        navigationBar.addSubview(closeButton)
        navigationBar.addSubview(titleBar)
        
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
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func closeTapped() {
        if RootViewController.sharedInstance() == nil {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            RootViewController.sharedInstance().popViewControllerAnimated(true)
        }
       
    }
    
    func setupLayout() {
        view.addConstraints([
            navigationBar.al_left == view.al_left,
            navigationBar.al_right == view.al_right,
            navigationBar.al_top == view.al_top,
            navigationBar.al_height == 50
        ])
        
        navigationBar.addConstraints([
            titleBar.al_left == navigationBar.al_left,
            titleBar.al_right == closeButton.al_left,
            titleBar.al_bottom == navigationBar.al_bottom,
            titleBar.al_top == navigationBar.al_top,
            
            closeButton.al_right == navigationBar.al_right - 10,
            closeButton.al_top == navigationBar.al_top + 10,
            closeButton.al_height == 30,
            closeButton.al_width == 30
        ])
    }
}
