//
//  KeyboardInstallationWalkthrough.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 7/1/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class KeyboardInstallationWalkthrough: UIViewController {
    var mainView: UIView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var toolbar: UIView
    var pager: UIPageControl
    var gotItButton: UIButton
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        mainView = UIView(frame: CGRectMake(15, 15, screenWidth - 30, screenHeight - 100))
        mainView.backgroundColor = UIColor.redColor()
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        
        toolbar = UIView()
        toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
        toolbar.backgroundColor = UIColor.blackColor()
        
        pager = UIPageControl()
        pager.setTranslatesAutoresizingMaskIntoConstraints(false)
        pager.pageIndicatorTintColor = UIColor.grayColor()
        pager.currentPageIndicatorTintColor = UIColor.whiteColor()
        pager.numberOfPages = 5
        
        gotItButton = UIButton()
        gotItButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        gotItButton.setTitle("got it".uppercaseString, forState: UIControlState.Normal)
        gotItButton.titleLabel?.font = ButtonFont
        gotItButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        gotItButton.addTarget(self, action: "didTapGotItButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(toolbar)
        view.addSubview(mainView)
        
        toolbar.addSubview(pager)
        toolbar.addSubview(gotItButton)
        
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
    
    func didTapGotItButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            toolbar.al_width == screenWidth,
            toolbar.al_height == 55,
            toolbar.al_bottom == view.al_bottom,
            
            pager.al_centerX == toolbar.al_centerX,
            pager.al_centerY == toolbar.al_centerY,
            
            gotItButton.al_left == pager.al_right + 70,
            gotItButton.al_right == toolbar.al_right - 10,
            gotItButton.al_top == toolbar.al_top + 10,
            gotItButton.al_bottom == toolbar.al_bottom - 10
            ])
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
   }
