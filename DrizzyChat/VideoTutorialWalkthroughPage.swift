//
//  VideoTutorialWalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 2/8/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoTutorialWalkthroughPage: WalkthroughPage {
    
    var videoPlayer: MPMoviePlayerController!
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        self.type = .VideoTutorialPage
    }
    
    override func setupPage() {
        var urlPath = NSBundle.mainBundle().pathForResource("tutorial-video", ofType: "mov")
        println("\(urlPath)")
        videoPlayer = MPMoviePlayerController(contentURL: NSURL.fileURLWithPath(urlPath!))
        videoPlayer.controlStyle = .None
        videoPlayer.repeatMode = .One
        videoPlayer.view.backgroundColor = UIColor(fromHexString: "#b2b2b2")
        
        var selfWidth = CGRectGetWidth(self.frame)
        var width = selfWidth * 0.7
        
        videoPlayer.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(videoPlayer.view)
        
        self.addConstraints([
            videoPlayer.view.al_top == self.subtitleLabel.al_bottom + 30,
            videoPlayer.view.al_width == width,
            videoPlayer.view.al_height == CGRectGetHeight(self.frame) * 0.7,
            videoPlayer.view.al_centerX == self.al_centerX
            ])
    }
    
    override func pageDidShow() {
        dispatch_after(dispatch_time_t(1.0), dispatch_get_main_queue(), {
            self.videoPlayer.play()
        })
    }
    
    override func pageDidHide() {
        videoPlayer.stop()
    }

}
