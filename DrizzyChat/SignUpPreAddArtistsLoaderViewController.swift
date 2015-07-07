//
//  SignUpPreAddArtistsLoader.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpPreAddArtistsLoaderViewController: WalkthroughViewController {
    var loaderPage: SignUpAddArtistsLoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUDProgressView.hide()
        
        let titleString = "Hey \(self.viewModel.user.name)"
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans-Semibold", size: 18)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1.5, range: titleRange)
        
        loaderPage = SignUpAddArtistsLoaderView()
        loaderPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        loaderPage.titleLabel.attributedText = title
        
        nextButton.setTitle("get started".uppercaseString, forState: .Normal)
    
        view.addSubview(loaderPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.hidden = true
        
        PKHUD.sharedHUD.hideAnimated()
        
        UIView.animateWithDuration(0, delay: 0, options: .CurveEaseIn, animations: {
            println("the length of the \(UIScreen.mainScreen().bounds.size.width)")
            self.loaderPage.cardImageView.center = CGPointMake(self.loaderPage.cardImageView.center.x - 3*UIScreen.mainScreen().bounds.size.width, self.loaderPage.cardImageView.center.y)
            }, completion: {
                (finished: Bool) in
                
                self.animationCard()
        });
        
        }
    
    func animationCard() {
        UIView.animateWithDuration(10, delay: 0, options: .CurveEaseIn, animations: {
            self.loaderPage.cardImageView.center = CGPointMake(self.loaderPage.cardImageView.center.x - 3*UIScreen.mainScreen().bounds.size.width, self.loaderPage.cardImageView.center.y)
            
            }, completion: {
                (finished: Bool) in
                self.loaderPage.cardImageView.center = CGPointMake(self.loaderPage.cardImageView.center.x + 3*UIScreen.mainScreen().bounds.size.width, self.loaderPage.cardImageView.center.y)
                self.animationCard()
                
        })
        
    }
    
    func slideUpNextButton() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveLinear, animations: {
            self.nextButton.hidden = false
            self.nextButton.frame.origin.y -= 50
            self.didAnimateUp = true
            self.hideButton = true
            }, completion: {
                (finished: Bool) in
        })
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            loaderPage.al_top == view.al_top,
            loaderPage.al_bottom == view.al_bottom,
            loaderPage.al_left == view.al_left,
            loaderPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.1, {
            self.slideUpNextButton()
        })
        
     
    }
    
     override func didTapNavButton() {
        let selectArtistvc = SelectArtistWalkthroughViewController(viewModel: self.viewModel)
        
        navigationController?.pushViewController(selectArtistvc, animated: true)
    }
}