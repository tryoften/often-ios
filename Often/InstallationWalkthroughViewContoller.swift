//
//  InstallationWalkthroughViewContoller.swift
//  Often
//
//  Created by Kervins Valcourt on 1/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class InstallationWalkthroughViewContoller: UIViewController {
    var installView: KeyboardInstallWalkthroughView
    var loader: AnimatedLoaderView?
    var completionView: KeyboardWalkthroughSuccessMessageView
    var viewModel: LoginViewModel
    var blurEffectView: UIVisualEffectView
    var inAppSetting: Bool

    init (viewModel: LoginViewModel, inAppSetting: Bool = false) {
        self.viewModel = viewModel

        self.inAppSetting = inAppSetting

        installView = KeyboardInstallWalkthroughView()
        installView.translatesAutoresizingMaskIntoConstraints = false

        completionView = KeyboardWalkthroughSuccessMessageView()
        completionView.translatesAutoresizingMaskIntoConstraints = false
        completionView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.72
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        if inAppSetting {

        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeLoader", name: UIApplicationDidBecomeActiveNotification, object: nil)

        view.addSubview(installView)

        setupLayout()
    }

    func setupLayout() {
        view.addConstraints([
            installView.al_top  == view.al_top,
            installView.al_bottom == view.al_bottom,
            installView.al_left == view.al_left,
            installView.al_right == view.al_right,
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if inAppSetting {
            installView.settingButton.setTitle("dismiss".uppercaseString, forState: .Normal)

        }
        
        installView.settingButton.addTarget(self, action: "settingsButtonDidTap:", forControlEvents: .TouchUpInside)
        completionView.finishedButton.addTarget(self, action: "finishedButtonDidTap:", forControlEvents: .TouchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func settingsButtonDidTap(sender: UIButton) {
        if inAppSetting {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            showLoader()

            let appSettingsString = "prefs:root=General&path=Keyboard/KEYBOARDS"
            if let appSettings = NSURL(string: appSettingsString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
    }

    func showLoader() {
        loader = AnimatedLoaderView()

        guard let loader = loader else {
            return
        }
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)

        view.addSubview(loader)
        view.addSubview(blurEffectView)

        view.addConstraints([
            loader.al_top == view.al_top,
            loader.al_bottom == view.al_bottom,
            loader.al_left == view.al_left,
            loader.al_right == view.al_right,

            blurEffectView.al_top == view.al_top,
            blurEffectView.al_bottom == view.al_bottom,
            blurEffectView.al_left == view.al_left,
            blurEffectView.al_right == view.al_right
        ])
    }

    func removeLoader() {
        delay(2.0) {
            self.loader?.removeFromSuperview()
            self.showCompleteMessage()
        }
    }

    func showCompleteMessage() {
        view.addSubview(completionView)
        view.addConstraints([
            completionView.al_top == view.al_top,
            completionView.al_bottom == view.al_bottom,
            completionView.al_left == view.al_left,
            completionView.al_right == view.al_right,
        ])
    }


    func finishedButtonDidTap(sender: UIButton) {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()

        viewModel.sessionManager.sessionManagerFlags.userSeenKeyboardInstallWalkthrough = true
        presentViewController(RootViewController(), animated: true, completion: nil)

    }

}