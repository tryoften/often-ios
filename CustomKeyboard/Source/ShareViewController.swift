//
//  ShareViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/29/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    var lyric: Lyric? {
        didSet {
            addShareButtons()
        }
    }
    
    var delegate: ShareViewControllerDelegate?
    
    var spotifyButton: UIButton?
    var soundcloudButton: UIButton?
    var youtubeButton: UIButton?
    var lyricButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.clipsToBounds = true
    }
    
    func addShareButtons() {
        var buttons: [UIButton] = []

        if let track = lyric?.track {
            
            func setupButton(target: AnyObject, button: UIButton, selectedColor: UIColor) {
                button.setTitleColor(selectedColor, forState: .Highlighted)
                button.setTitleColor(selectedColor, forState: .Selected)
                button.setTitleColor(selectedColor, forState: .Highlighted | .Selected)
                button.setTranslatesAutoresizingMaskIntoConstraints(false)
                button.addTarget(self, action: "buttonSelected:", forControlEvents: .TouchUpInside)
            }
            
            func addSeperatorNextTo(button: UIButton) -> UIView {
                var seperator = UIView(frame: CGRectZero)
                seperator.setTranslatesAutoresizingMaskIntoConstraints(false)
                seperator.backgroundColor = UIColor(fromHexString: "#d8d8d8")
                
                self.view.addSubview(seperator)
                
                let buttonAL = button as ALView
                let seperatorAL = seperator as ALView
                
                let positionConstraint = seperatorAL.al_left == buttonAL.al_right
                positionConstraint.priority = 250
                
                self.view.addConstraints([
                    seperatorAL.al_width == 1.0,
                    seperatorAL.al_height == buttonAL.al_height,
                    seperatorAL.al_top == buttonAL.al_top,
                    positionConstraint
                ])
                
                return seperator
            }
            
            // Spotify button
            if track.spotifyURL != nil {
                let button = UIButton(frame: CGRectZero)
                button.setTitle("\u{f6b1}", forState: .Normal)
                setupButton(self, button, UIColor(fromHexString: "#b8c81f"))
                self.spotifyButton = button
                buttons.append(button)
            }
            
            // Soundcloud button
            if track.soundcloudURL != nil {
                let button = UIButton(frame: CGRectZero)
                button.setTitle("\u{f6b3}", forState: .Normal)
                setupButton(self, button, UIColor(fromHexString: "#ed7233"))
                
                self.soundcloudButton = button
                buttons.append(button)
            }
            
            if track.youtubeURL != nil {
                let button = UIButton(frame: CGRectZero)
                button.setTitle("\u{f630}", forState: .Normal)
                setupButton(self, button, UIColor(fromHexString: "#ce594b"))
                
                self.youtubeButton = button
                buttons.append(button)
            }
            
            let view = self.view as ALView
            var prevButton: ALView?
            for (index, button) in enumerate(buttons) {
                let buttonAL = button as ALView
                button.titleLabel!.font = UIFont(name: "SSSocialCircle", size: 30)
                view.addSubview(button)
                let seperator = addSeperatorNextTo(button)
                let seperatorAL = seperator as ALView
                
                view.addConstraints([
                    buttonAL.al_height == view.al_height,
                    buttonAL.al_width == view.al_width / CGFloat(buttons.count),
                    buttonAL.al_top == view.al_top
                ])
                
                if let previousButton = prevButton {
                    view.addConstraint(buttonAL.al_left == previousButton.al_right)
                } else {
                    let constraint = buttonAL.al_left == view.al_left
                    constraint.priority = 750
                    view.addConstraint(constraint)
                }
                prevButton = buttonAL
            }
        }
    }
    
    internal func buttonSelected(button: UIButton!) {
        button.selected = !button.selected
        
        
        if self.spotifyButton == button {
            
        }
        
        if self.soundcloudButton == button {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
    }
}

protocol ShareViewControllerDelegate {
    func shareViewControllerDidToggleShareOption(shareViewController: ShareViewController, option: ShareOption, url: NSURL)
    func shareViewControllerDidCancel(shareViewController: ShareViewController)
}
