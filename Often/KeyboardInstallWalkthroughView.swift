//
//  KeyboardInstallWalkthroughView.swift
//  Often
//
//  Created by Kervins Valcourt on 1/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardInstallWalkthroughView: UIView {
    let backgroundView: UIImageView
    let stilliphoneImageView: UIImageView
    let iphoneGifView: UIWebView
    let subView: UIView
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    let settingButton: UIButton

    private var iphoneGifViewTopMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 210
        }

        if Diagnostics.platformString().number == 5 {
            return 139
        }

        return 145
    }

    private var iphoneGifViewLeftMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 23
        }

        if Diagnostics.platformString().number == 5 {
            return 19
        }

        return 24
    }

    private var iphoneGifViewRightMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 16
        }

        if Diagnostics.platformString().number == 5 {
            return 13
        }

        return 16
    }

    private var iphoneGifViewBottomMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 184
        }

        return 210
    }

    private var stilliphoneImageViewTopMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 60
        }
        return 0
    }

    private var subtitleLabelLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 40
        }
        return 50
    }

    private var subViewTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 {
            return 120
        }
        return 150
    }


    private var stilliphoneImageViewLeftMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 70
        }
        return 50
    }

    private var stilliphoneImageViewRightMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 70
        }
        return 50
    }

    private var settingButtonHeight: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" {
            return 50
        }
        return 0
    }

    override init(frame: CGRect) {
        let filePath = NSBundle.mainBundle().pathForResource("OftenInstallGIF", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        
        backgroundView = UIImageView()
        backgroundView.contentMode = .ScaleAspectFit
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named: "installbackground")

        stilliphoneImageView = UIImageView()
        stilliphoneImageView.contentMode = .ScaleAspectFit
        stilliphoneImageView.translatesAutoresizingMaskIntoConstraints = false
        stilliphoneImageView.image = UIImage(named: "installdevice")

        iphoneGifView = UIWebView()
        iphoneGifView.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        iphoneGifView.userInteractionEnabled = false
        iphoneGifView.scalesPageToFit = true
        iphoneGifView.translatesAutoresizingMaskIntoConstraints = false
    

        subView = UIView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.backgroundColor = WhiteColor
        subView.layer.shadowOffset = CGSizeMake(0, 0)
        subView.layer.shadowOpacity = 0.8
        subView.layer.shadowColor = DarkGrey.CGColor
        subView.layer.shadowRadius = 4


        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Montserrat", size: 18)
        titleLabel.textColor = WalkthroughTitleFontColor
        titleLabel.alpha = 0.90
        titleLabel.text = "Install Often"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "OpenSans", size: 12)
        subtitleLabel.alpha = 0.54
        subtitleLabel.textColor = WalkthroughSubTitleFontColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Remember to allow Full-Access. We never read or save any sensitive info fam :)"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        settingButton = UIButton()
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.setTitle("go to settings".uppercaseString, forState: .Normal)
        settingButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        settingButton.setTitleColor(WhiteColor , forState: .Normal)
        settingButton.backgroundColor = TealColor
        settingButton.layer.cornerRadius = 20
        settingButton.clipsToBounds = true

        super.init(frame: frame)

        addSubview(backgroundView)
        addSubview(stilliphoneImageView)
        addSubview(iphoneGifView)
        addSubview(subView)

        subView.addSubview(titleLabel)
        subView.addSubview(subtitleLabel)
        subView.addSubview(settingButton)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     func setupLayout() {
        addConstraints([
            backgroundView.al_top == al_top,
            backgroundView.al_bottom == al_bottom,
            backgroundView.al_left == al_left,
            backgroundView.al_right == al_right,

            stilliphoneImageView.al_top == al_top - stilliphoneImageViewTopMargin,
            stilliphoneImageView.al_left == al_left + stilliphoneImageViewLeftMargin,
            stilliphoneImageView.al_right == al_right - stilliphoneImageViewRightMargin,
            stilliphoneImageView.al_bottom == al_bottom + 50,

            iphoneGifView.al_top == stilliphoneImageView.al_top + iphoneGifViewTopMargin,
            iphoneGifView.al_left == stilliphoneImageView.al_left + iphoneGifViewLeftMargin,
            iphoneGifView.al_right == stilliphoneImageView.al_right - iphoneGifViewRightMargin,
            iphoneGifView.al_bottom == stilliphoneImageView.al_bottom - iphoneGifViewBottomMargin,

            subView.al_bottom == al_bottom,
            subView.al_left == al_left,
            subView.al_right == al_right,
            subView.al_top == al_centerY + subViewTopMargin,

            titleLabel.al_bottom == subtitleLabel.al_top,
            titleLabel.al_left == al_left,
            titleLabel.al_right == al_right,
            titleLabel.al_height == 36,

            subtitleLabel.al_centerY == subView.al_centerY - 16,
            subtitleLabel.al_left == al_left + subtitleLabelLeftAndRightMargin,
            subtitleLabel.al_right == al_right - subtitleLabelLeftAndRightMargin,
            subtitleLabel.al_height == 40,

            settingButton.al_height == 40,
            settingButton.al_left == al_left + 100,
            settingButton.al_right == al_right - 100,
            settingButton.al_top == subtitleLabel.al_bottom + 15
            ])
    }
}