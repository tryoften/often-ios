//
//  ViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        var button = UIButton(frame: CGRectMake(100, 100, 400, 50))
        button.setTitle("Open Settings", forState: UIControlState.Normal)
        button.addTarget(self, action: "didTapButton", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func didTapButton() {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

