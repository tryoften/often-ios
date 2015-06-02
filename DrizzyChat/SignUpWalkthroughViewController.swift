//
//  SignUpWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpWalkthroughViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        var signUpOrLoginView = SignUpOrLoginView()
        signUpOrLoginView.frame = view.bounds
        view.addSubview(signUpOrLoginView)
        
    }
}