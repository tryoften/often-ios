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
    var seperatorView: UIView!
    var spotifyButton: UIButton?
    var soundcloudButton: UIButton?
    var youtubeButton: UIButton?
    var lyricButton: UIButton?
    var buttons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clearColor()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.clipsToBounds = true
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = UIColor(fromHexString: "#d8d8d8")
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(seperatorView)
        
        view.addConstraints([
            seperatorView.al_bottom == view.al_bottom,
            seperatorView.al_width == view.al_width,
            seperatorView.al_left == view.al_left,
            seperatorView.al_height == 1.0
        ])
        
        buttons = []
    }
    
    func addShareButtons() {
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []
        
        if let track = lyric?.track {
            
            func setupButton(button: UIButton, selectedColor: UIColor) {
                button.setTitleColor(UIColor(fromHexString: "#cecece"), forState: .Normal)
                button.setTitleColor(selectedColor, forState: .Highlighted)
                button.setTitleColor(selectedColor, forState: .Selected)
                button.setTitleColor(selectedColor, forState: .Highlighted | .Selected)
                button.setTranslatesAutoresizingMaskIntoConstraints(false)
                button.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 0, bottom: 0, right: 0)
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
                setupButton(button, UIColor(fromHexString: "#b8c81f"))
                self.spotifyButton = button
                buttons.append(button)
            }
            
            // Soundcloud button
            if track.soundcloudURL != nil {
                let button = UIButton(frame: CGRectZero)
                button.setTitle("\u{f6b3}", forState: .Normal)
                setupButton(button, UIColor(fromHexString: "#ed7233"))
                
                self.soundcloudButton = button
                buttons.append(button)
            }
            
            if track.youtubeURL != nil {
                let button = UIButton(frame: CGRectZero)
                button.setTitle("\u{f630}", forState: .Normal)
                setupButton(button, UIColor(fromHexString: "#ce594b"))
                
                self.youtubeButton = button
                buttons.append(button)
            }
            
            if lyric?.text != nil {
                let button = UIButton(frame: CGRectZero)
                button.imageView?.contentMode = .ScaleAspectFit
                button.setImage(UIImage(named: "ShareLyricOff"), forState: .Normal)
                button.setImage(UIImage(named: "ShareLyricOn"), forState: .Highlighted)
                button.setImage(UIImage(named: "ShareLyricOn"), forState: .Selected)
                setupButton(button, UIColor(fromHexString: "#ffae36"))
                button.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 0, bottom: 7.0, right: 0)
                button.selected = true
                
                self.lyricButton = button
                buttons.append(button)
            }
            
            let view = self.view as ALView
            var prevButton: ALView?
            for (index, button) in enumerate(buttons) {
                let buttonAL = button as ALView
                button.titleLabel!.font = UIFont(name: "SSSocialCircle", size: 32)
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
        
        var option: ShareOption = .Unknown
        var shareURL: NSURL? = nil
        
        if spotifyButton == button {
            option = .Spotify
            shareURL = lyric?.track?.spotifyURL
        }
        
        if soundcloudButton == button {
            option = .Soundcloud
            shareURL = lyric?.track?.soundcloudURL
        }
        
        if youtubeButton == button {
            option = .YouTube
            shareURL = lyric?.track?.youtubeURL
        }
        
        if lyricButton == button {
            option = .Lyric
        }
        
        delegate?.shareViewControllerDidToggleShareOption(self, option: option, selected: button.selected, url: shareURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
    }
}

protocol ShareViewControllerDelegate {
    func shareViewControllerDidToggleShareOption(shareViewController: ShareViewController, option: ShareOption, selected: Bool, url: NSURL?)
    func shareViewControllerDidCancel(shareViewController: ShareViewController)
}
