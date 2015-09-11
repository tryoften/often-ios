//
//  CreateAccountViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/10/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class CreateAccountViewController: UIViewController {
    var viewModel: SignupViewModel
    var createAccountView: CreateAccountView
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        createAccountView = CreateAccountView()
        createAccountView.setTranslatesAutoresizingMaskIntoConstraints(false)
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(createAccountView)
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAccountView.cancelButton.addTarget(self,  action: "didTapcancelButton:", forControlEvents: .TouchUpInside)
        
    }
    
    func didTapcancelButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            createAccountView.al_bottom == view.al_bottom,
            createAccountView.al_top == view.al_top,
            createAccountView.al_left == view.al_left,
            createAccountView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
}