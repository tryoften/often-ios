//
//  KeyboardInstallAlertViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/5/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardInstallAlertViewController: AlertViewController {

    override init(alertView: AlertView.Type) {
        super.init(alertView: alertView)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardInstallAlertViewController.completedWalkthrough), name: "CompletedWalkthrough", object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        alertView.actionButton.addTarget(self, action: #selector(KeyboardInstallAlertViewController.didTapActionButton(_:)), forControlEvents: .TouchUpInside)

        if let alertView = alertView as? KeyboardInstallAlertView {
            alertView.skipButton.addTarget(self, action: #selector(AlertViewController.dismissView), forControlEvents: .TouchUpInside)
        }
    }

    func didTapActionButton(sender: UIButton) {
        let walkthroughViewController = InstallationWalkthroughViewContoller(viewModel: LoginViewModel(sessionManager: SessionManager.defaultManager), inAppSetting: false)

        presentViewController(walkthroughViewController, animated: true, completion: nil)
    }

    func completedWalkthrough() {
        delay(1) {
            PKHUD.sharedHUD.hide(animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}