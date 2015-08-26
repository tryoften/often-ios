//
//  AppSettingsViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView
    var settingOptions: NSDictionary = [
        "Account": ["Name", "Email", "Password", "Push Notifications"],
        "Actions": ["How To Install Often", "Rate In App Store", "Support"],
        "About": ["FAQ", "Privacy Policy", "Terms Of Use", "Licenses"]
    ]
    
    var sectionHeaders: NSArray = [
        "Account",
        "Actions",
        "About"
    ]
    
    init() {
        tableView = UITableView()
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        return cell
    }
    
    func setupLayout() {
        view.addConstraints([
            tableView.al_left == view.al_left,
            tableView.al_top == view.al_top,
            tableView.al_bottom == view.al_bottom,
            tableView.al_right == view.al_right
        ])
    }
}
