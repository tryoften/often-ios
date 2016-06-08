//
//  AlertViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 6/2/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AlertViewController: UIViewController {
    var backgroundTintView: UIView
    var alertView: AlertView

    private var alertViewTopAndBottomMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 120
        }
        return 158
    }

    private var alertViewLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 32
        }
        return 42
    }

    init(alertView: AlertView.Type = AlertView.self) {
        backgroundTintView = UIView()
        backgroundTintView.translatesAutoresizingMaskIntoConstraints = false
        backgroundTintView.backgroundColor = BlackColor
        backgroundTintView.alpha = 0.74

        self.alertView = alertView.init()
        self.alertView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.addSubview(backgroundTintView)
    }

    func setupLayout() {
        view.addConstraints([
            alertView.al_centerX == view.al_centerX,
            alertView.al_centerY == view.al_centerY,
            alertView.al_top == view.al_top + alertViewTopAndBottomMargin,
            alertView.al_bottom == view.al_bottom - alertViewTopAndBottomMargin,
            alertView.al_right == view.al_right - alertViewLeftAndRightMargin,
            alertView.al_left == view.al_left + alertViewLeftAndRightMargin,

            backgroundTintView.al_top == view.al_top,
            backgroundTintView.al_left == view.al_left,
            backgroundTintView.al_right == view.al_right,
            backgroundTintView.al_bottom == view.al_bottom - 49,
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        view.addSubview(alertView)
        setupLayout()
        alertView.animate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.actionButton.addTarget(self, action: #selector(AlertViewController.dismissView), forControlEvents: .TouchUpInside)
    }

    func dismissView() {
        SessionManagerFlags.defaultManagerFlags.userSeenKeyboardInstallWalkthrough = false
        dismissViewControllerAnimated(true, completion: nil)
    }
}