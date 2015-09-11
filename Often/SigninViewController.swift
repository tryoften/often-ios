//
//  SigninViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/10/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SigninViewController: UIViewController {
    var viewModel: SignupViewModel
    var signinView: SigninView
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        signinView = SigninView()
        signinView.setTranslatesAutoresizingMaskIntoConstraints(false)
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(signinView)
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinView.cancelButton.addTarget(self,  action: "didTapcancelButton:", forControlEvents: .TouchUpInside)
        
    }
    
    func didTapcancelButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            signinView.al_bottom == view.al_bottom,
            signinView.al_top == view.al_top,
            signinView.al_left == view.al_left,
            signinView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
}