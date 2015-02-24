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
    @IBOutlet weak var rateUsButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
    var loginIndicatorView: LoginIndicatorView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        loginIndicatorView = LoginIndicatorView(frame: CGRectZero)
        loginIndicatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(nibName: "HomeViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        view.addSubview(loginIndicatorView)
        
        setupLayout()
        
        if isIPhone5() {
            topMargin.constant = 190
        }
        
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            if let fullName = currentUser["fullName"] as? String {
                loginIndicatorView.nameLabel.text = "Wassup, \(fullName)"
            } else {
                loginIndicatorView.nameLabel.text = "Wassup homie"
            }
        }
        
        seeIntroButton.addTarget(self, action: "didTapSeeIntroButton", forControlEvents: .TouchUpInside)
        rateUsButton.addTarget(self, action: "didTapRateUsButton", forControlEvents: .TouchUpInside)
        feedbackButton.addTarget(self, action: "didTapFeedbackButton", forControlEvents: .TouchUpInside)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "visitedHomeView")
    }
    
    func didTapSeeIntroButton() {
        var walkthroughVC = WalkthroughViewController()
        presentViewController(walkthroughVC, animated: true, completion: nil)
    }
    
    func didTapRateUsButton() {
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/id955090584")!)
    }
    
    func didTapFeedbackButton() {
        var email = "feedback@drizzyapp.com"
        var subject = "Yo! drizzy app. Here's some feedback".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        var body = "I think the app is awesome! But here's what I'd like to see next: \n\n *fill in the blank*".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        var link = "mailto:\(email)?subject=\(subject)&body=\(body)"

        println(link)
        
        UIApplication.sharedApplication().openURL(NSURL(string: link)!)
    }
    
    func setupLayout() {
        view.addConstraints([
            loginIndicatorView.al_width == view.al_width,
            loginIndicatorView.al_left == view.al_left,
            loginIndicatorView.al_height == 80,
            loginIndicatorView.al_bottom == view.al_bottom
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
