//
//  PackImagePickerViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 7/21/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackImagePickerViewController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.translucent = false
        navigationBar.barTintColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        navigationBar.tintColor = UIColor.oftBlack74Color()
        navigationItem.title = "All Photos"
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "Montserrat", size: 15.0)!
        ]
        
        allowsEditing = false
        sourceType = .PhotoLibrary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}
