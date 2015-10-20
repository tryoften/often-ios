//
//  CompleteInstallationViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 10/16/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class CompleteInstallationViewController: UIViewController {
    var viewModel: SignupViewModel
    var completeInstallationView: CompleteInstallationView
   
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        
        completeInstallationView = CompleteInstallationView()
        completeInstallationView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
                
        view.addSubview(completeInstallationView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            completeInstallationView.al_bottom == view.al_bottom,
            completeInstallationView.al_top == view.al_top,
            completeInstallationView.al_left == view.al_left,
            completeInstallationView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeInstallationView.finishedButton.addTarget(self, action: "didTapFinishedButton:", forControlEvents: .TouchUpInside)
    }
    
    func didTapFinishedButton(sender: UIButton) {
        
        if (SlideNavigationController.sharedInstance() == nil) {
            presentViewController(RootViewController(), animated: true, completion: nil )
            
        }
    }
}