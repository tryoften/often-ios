//
//  SignUpPostAddArtistLoaderViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation


class SignUpPostAddArtistsLoaderViewController: WalkthroughViewController {
    var loaderPage: SignUpPostAddArtistsLoaderView!
    var indexOfAnimationCompletion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaderPage = SignUpPostAddArtistsLoaderView()
        loaderPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(loaderPage)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = true
        
        UIView.animateWithDuration(0, delay: 0, options: .CurveEaseIn, animations: {
            println("the length of the \(UIScreen.mainScreen().bounds.size.width)")
            self.loaderPage.cardImageView.center = CGPointMake(self.loaderPage.cardImageView.center.x - 3*UIScreen.mainScreen().bounds.size.width, self.loaderPage.cardImageView.center.y)
            }, completion: {
                (finished: Bool) in
                
                self.animationCard()
        });
    }
    
    func animationCard() {
        UIView.animateWithDuration(8, delay: 0, options: .CurveEaseIn, animations: {
            self.loaderPage.cardImageView.center = CGPointMake(self.loaderPage.cardImageView.center.x - 3*UIScreen.mainScreen().bounds.size.width, self.loaderPage.cardImageView.center.y)
            
            self.indexOfAnimationCompletion++
            
            }, completion: {
                (finished: Bool) in
                if self.indexOfAnimationCompletion < 1 {
                    self.loaderPage.cardImageView.center = CGPointMake(self.loaderPage.cardImageView.center.x + 3*UIScreen.mainScreen().bounds.size.width, self.loaderPage.cardImageView.center.y)
                    
                    self.animationCard()
                } else {
                    self.presentViewController(TabBarController(), animated: true, completion: nil)
                    self.viewModel.delegate = nil
                }
                
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
    }
}