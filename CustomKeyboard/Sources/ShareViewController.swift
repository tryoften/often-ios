//
//  ShareViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/29/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

func addSeperatorNextTo(button: UIView, leftSide: Bool) -> UIView {
    var seperator = UIView(frame: CGRectZero)
    seperator.setTranslatesAutoresizingMaskIntoConstraints(false)
    seperator.backgroundColor = UIColor(fromHexString: "#d8d8d8")
    button.addSubview(seperator)
    
    var positionConstraint: NSLayoutConstraint!
    
    positionConstraint = seperator.al_left == ((leftSide) ? button.al_left : button.al_right)
    positionConstraint.priority = 250
    
    button.addConstraints([
        seperator.al_width == 1.0,
        seperator.al_height == button.al_height,
        seperator.al_top == button.al_top,
        positionConstraint
    ])
    
    return seperator
}

func addSeperatorBelow(view: UIView) -> UIView {
    var seperator = UIView(frame: CGRectZero)
    seperator.setTranslatesAutoresizingMaskIntoConstraints(false)
    seperator.backgroundColor = UIColor(fromHexString: "#d8d8d8")
    view.addSubview(seperator)
    
    view.addConstraints([
        seperator.al_height == 1.0,
        seperator.al_width == view.al_width,
        seperator.al_bottom == view.al_bottom,
        seperator.al_left == view.al_left
    ])
    
    return seperator
}

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
    var buttonViews: [UIView]!

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
        buttonViews = []
    }
    
    func addShareButtons() {
        
        func setupButton(button: UIButton, selectedColor: UIColor) {
            let buttonColor = UIColor(fromHexString: "#cecece")
            button.layer.cornerRadius = 2.0
            button.clipsToBounds = true
            button.setTitleColor(buttonColor, forState: .Normal)
            button.setTitleColor(selectedColor, forState: .Highlighted)
            button.setTitleColor(selectedColor, forState: .Selected)
            button.setTitleColor(selectedColor, forState: .Highlighted | .Selected)
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 0, bottom: 0, right: 0)
            button.addTarget(self, action: "buttonSelected:", forControlEvents: .TouchUpInside)
        }

        for button in buttons {
            button.removeFromSuperview()
        }
        for container in buttonViews {
            container.removeFromSuperview()
        }
        buttons = []
        buttonViews = []
        
        if let track = lyric?.track {
            
            // Spotify button
            if track.spotifyURL != nil && !track.spotifyURL!.isEmpty {
                let buttonView = UIView()
                buttonView.setTranslatesAutoresizingMaskIntoConstraints(false)
                let button = UIButton(frame: CGRectZero)
                button.titleLabel!.font = UIFont(name: "SSSocialRegular", size: 32)
                button.setTitle("\u{f6b1}", forState: .Normal)
                setupButton(button, UIColor(fromHexString: "#38D95A"))
                buttonView.addSubview(button)

                spotifyButton = button
                buttons.append(button)
                buttonViews.append(buttonView)
            }
            
            // Soundcloud button
            if track.soundcloudURL != nil && !track.soundcloudURL!.isEmpty {
                let buttonView = UIView()
                buttonView.setTranslatesAutoresizingMaskIntoConstraints(false)
                let button = UIButton(frame: CGRectZero)
                button.titleLabel!.font = UIFont(name: "SSSocialCircle", size: 32)
                button.setTitle("\u{f6b3}", forState: .Normal)
                setupButton(button, UIColor(fromHexString: "#ed7233"))
                buttonView.addSubview(button)

                soundcloudButton = button
                buttons.append(button)
                buttonViews.append(buttonView)
            }
            
            if track.youtubeURL != nil && !track.youtubeURL!.isEmpty {
                let buttonView = UIView()
                buttonView.setTranslatesAutoresizingMaskIntoConstraints(false)
                let button = UIButton(frame: CGRectZero)
                button.titleLabel!.font = UIFont(name: "SSSocialCircle", size: 32)
                button.setTitle("\u{f630}", forState: .Normal)
                setupButton(button, UIColor(fromHexString: "#ce594b"))
                buttonView.backgroundColor = UIColor.blackColor()
                buttonView.addSubview(button)

                youtubeButton = button
                buttons.append(button)
                buttonViews.append(buttonView)
            }
        }
        
        if lyric?.text != nil {
            let buttonView = UIView()
            buttonView.setTranslatesAutoresizingMaskIntoConstraints(false)
            let button = UIButton(frame: CGRectZero)
            button.imageView?.contentMode = .ScaleAspectFit
            button.setImage(UIImage(named: "ShareLyricOff"), forState: .Normal)
            button.setImage(UIImage(named: "ShareLyricOn"), forState: .Highlighted)
            button.setImage(UIImage(named: "ShareLyricOn"), forState: .Selected)
            setupButton(button, UIColor(fromHexString: "#ffae36"))
            button.contentEdgeInsets = UIEdgeInsets(top: -8.0, left: 0, bottom: -8.0, right: 0)
            button.selected = true
            buttonView.addSubview(button)
            
            lyricButton = button
            buttons.append(button)
            buttonViews.append(buttonView)
        }

        var prevButton: ALView?
        for (index, container) in enumerate(buttonViews) {
            view.addSubview(container)
            let seperator = addSeperatorNextTo(container, false)
            let button = buttons[index]
            
            view.addConstraints([
                container.al_height == view.al_height,
                container.al_width == view.al_width / CGFloat(buttonViews.count),
                container.al_top == view.al_top,
                button.al_top == container.al_top + 5,
                button.al_bottom == container.al_bottom - 5,
                button.al_left == container.al_left + 5,
                button.al_right == container.al_right - 5
            ])
            
            if let previousButton = prevButton {
                view.addConstraint(container.al_left == previousButton.al_right)
            } else {
                let constraint = container.al_left == view.al_left
                constraint.priority = 750
                view.addConstraint(constraint)
            }
            prevButton = container
        }
    }
    
    internal func buttonSelected(button: UIButton!) {
        button.selected = !button.selected
        var selectedOptions = [ShareOption: NSURL]()
        var buttonTag = ShareOption.Unknown.description
        let duration = 0.3 / 3
        
        button.transform = CGAffineTransformMakeScale(1, 1);
        
        UIView.animateKeyframesWithDuration(duration, delay: 0, options: nil, animations: {
            button.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: { done in
                UIView.animateKeyframesWithDuration(duration, delay: 0, options: nil, animations: {
                    button.transform = CGAffineTransformMakeScale(0.9, 0.9)
                    }, completion: { done in
                        UIView.animateKeyframesWithDuration(duration, delay: 0, options: nil, animations: {
                            }, completion: { done in
                                button.transform = CGAffineTransformMakeScale(1, 1)
                        })
                })
        })
        
        if button == spotifyButton {
            buttonTag = ShareOption.Spotify.description
        } else if button == soundcloudButton {
            buttonTag = ShareOption.Soundcloud.description
        } else if button == youtubeButton {
            buttonTag = ShareOption.YouTube.description
        } else if button == lyricButton {
            buttonTag = ShareOption.Lyric.description
        }
        
        SEGAnalytics.sharedAnalytics().track("ShareOption_Toggled", properties: [
            "tag": buttonTag,
            "selected": button.selected
        ])
        
        if let options = lyric?.track?.getShareOptions() {
            if spotifyButton != nil && spotifyButton!.selected {
                selectedOptions[.Spotify] = options[.Spotify]
            }
            
            if soundcloudButton != nil && soundcloudButton!.selected {
                selectedOptions[.Soundcloud] = options[.Soundcloud]
            }
            
            if youtubeButton != nil && youtubeButton!.selected {
                selectedOptions[.YouTube] = options[.YouTube]
            }
        }
        
        if lyricButton!.selected {
            selectedOptions[.Lyric] = NSURL(string: "drizzy:url")
        }
        
        delegate?.shareViewControllerDidToggleShareOptions(self, options: selectedOptions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        
    }
}

protocol ShareViewControllerDelegate {
    func shareViewControllerDidToggleShareOptions(shareViewController: ShareViewController, options: [ShareOption: NSURL])
    func shareViewControllerDidCancel(shareViewController: ShareViewController)
}
