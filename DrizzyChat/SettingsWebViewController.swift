//
//  SettingsWebViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 7/2/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SettingsWebViewController: UIViewController {
    var navigationBar: UIView
    var closeButton: UIButton
    var webView: UIWebView
    
    init(website: String) {
        navigationBar = UIView()
        navigationBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        navigationBar.backgroundColor = SettingsTableViewControllerNavBarBackgroundColor

        closeButton = UIButton()
        closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        closeButton.setImage(UIImage(named: "close artists"), forState: UIControlState.Normal)
        closeButton.imageView?.contentMode = .ScaleAspectFill

        let requestURL = NSURL(string: website)
        let request = NSURLRequest(URL: requestURL!)
        
        webView = UIWebView(frame: CGRectMake(0, 50, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webView.loadRequest(request)
        
        super.init(nibName: nil, bundle: nil)
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(webView)
        view.addSubview(navigationBar)
        navigationBar.addSubview(closeButton)
        
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            navigationBar.al_left == view.al_left,
            navigationBar.al_right == view.al_right,
            navigationBar.al_top == view.al_top,
            navigationBar.al_height == 50
        ])
        
        navigationBar.addConstraints([
            closeButton.al_left == navigationBar.al_left,
            closeButton.al_top == navigationBar.al_top,
            closeButton.al_height == 50,
            closeButton.al_width == 50
        ])
    }
}
