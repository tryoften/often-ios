//
//  TextMessageViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 10/15/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class TextMessageViewController: UIViewController {
    var viewModel: SignupViewModel
    var textMessageOnBoardingView: TextMessageOnBoardingView
    var keyboardconnectivityWormhole: MMWormhole
    var keyboardConnectivityListeningWormhole: MMWormholeSession
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        
        textMessageOnBoardingView = TextMessageOnBoardingView()
        textMessageOnBoardingView.translatesAutoresizingMaskIntoConstraints = false
        textMessageOnBoardingView.textMessageBubbleTwo.hidden = true
        
        keyboardConnectivityListeningWormhole = MMWormholeSession.sharedListeningSession()
        
        keyboardconnectivityWormhole = MMWormhole(applicationGroupIdentifier: AppSuiteName, optionalDirectory: "wormhole")

        
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(textMessageOnBoardingView)
        
        keyboardConnectivityListeningWormhole.listenForMessageWithIdentifier("keyboardOpen") { messageObject -> Void in
            self.textMessageOnBoardingView.textMessageBubbleTwo.hidden = false
        }
        
        keyboardConnectivityListeningWormhole.listenForMessageWithIdentifier("firstSearch") { messageObject -> Void in
            self.displayCompleteView()
        }
        
        keyboardConnectivityListeningWormhole.activateSessionListening()
    
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            textMessageOnBoardingView.al_bottom == view.al_bottom,
            textMessageOnBoardingView.al_top == view.al_top,
            textMessageOnBoardingView.al_left == view.al_left,
            textMessageOnBoardingView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textMessageOnBoardingView.dummyTextField.becomeFirstResponder()
    }
    
    func displayCompleteView() {
        let completeInstallationViewController = CompleteInstallationViewController(viewModel: self.viewModel)
        presentViewController(completeInstallationViewController, animated: true, completion: nil )
        
    }
    
    
}