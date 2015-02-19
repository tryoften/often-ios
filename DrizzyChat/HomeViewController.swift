//
//  HomeViewController.swift
//  Drizzy
//
//  Created by Luc Success on 2/3/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var seeIntroButton: UIButton!
    @IBOutlet weak var suggestLyricsButton: UIButton!
    @IBOutlet weak var rateUsButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
//    var loginIndicationView:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isIPhone5() {
            topMargin.constant = 190
        }

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
