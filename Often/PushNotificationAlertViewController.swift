//
//  PushNotificationAlertViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 6/6/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PushNotificationAlertViewController: AlertViewController {

    override init(alertView: AlertView.Type = PushNotifcationAlertView.self) {
        super.init(alertView: alertView)

        SessionManagerFlags.defaultManagerFlags.userHasSeenPushNotificationView = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let alertView = alertView as? PushNotifcationAlertView {
            alertView.declineButton.addTarget(self, action: #selector(PushNotificationAlertViewController.didTapDeclineButton(_:)), for: .touchUpInside)
            alertView.actionButton.addTarget(self, action: #selector(PushNotificationAlertViewController.didTapActionButton(_:)), for: .touchUpInside)
        }
    }

     func didTapDeclineButton(_ sender: UIButton) {
        SessionManager.defaultManager.updateUserPushNotificationStatus(false)

        dismiss(animated: true, completion: nil)
    }

    func didTapActionButton(_ sender: UIButton) {
        SessionManager.defaultManager.updateUserPushNotificationStatus(true)

        dismiss(animated: true, completion: nil)
    }
}
