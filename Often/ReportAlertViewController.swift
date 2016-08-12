//
//  ReportAlertViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class ReportAlertViewController: AlertViewController {

    override init(alertView: AlertView.Type = ReportAlertView.self) {
        super.init(alertView: alertView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let alertView = alertView as? ReportAlertView {
            alertView.actionButton.addTarget(self, action: #selector(ReportAlertViewController.didTapActionButton(_:)), forControlEvents: .TouchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapActionButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
