//
//  AddArtistModalContainerViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class AddArtistModalContainerViewController: UIViewController {
    var mainView: UIView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var closeButton: UIButton
    var currentArtist: Artist? // set before presentation
    var addArtistModal: AddArtistModalCollectionViewController!
    var sessionManager: SessionManager
    
    var lastLocation: CGPoint? // pan gesture relativity
    var originalPoint: CGPoint? // snap back
    var snap: UISnapBehavior?
    var animator: UIDynamicAnimator?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        mainView = UIView(frame: CGRectMake(15, 15, screenWidth - 30, screenHeight - 120))
        mainView.backgroundColor = UIColor.clearColor()
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        
        closeButton = UIButton()
        closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        closeButton.backgroundColor = UIColor.blackColor()
        closeButton.setTitle("CLOSE", forState: UIControlState.Normal)
        closeButton.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 15.0)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        sessionManager = SessionManager.defaultManager
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        addArtistModal = AddArtistModalCollectionViewController(collectionViewLayout: provideCollectionFlowLayout())
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: UIControlEvents.TouchUpInside)

        addArtistModal = AddArtistModalCollectionViewController(collectionViewLayout: provideCollectionFlowLayout())
        
        mainView.addSubview(addArtistModal!.view)
        addArtistModal?.view.layer.cornerRadius = 5.0
        addArtistModal?.view.frame = mainView.bounds
        
        var panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panHandler:")
        animator = UIDynamicAnimator(referenceView: view)
        mainView.addGestureRecognizer(panRecognizer)
        
        view.addSubview(closeButton)
        view.addSubview(mainView)
        
        setupLayout()
    }
    
    func provideCollectionFlowLayout() -> UICollectionViewFlowLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(mainView.bounds.width, 50)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(mainView.bounds.width, 400)
        flowLayout.itemSize = CGSizeMake(mainView.bounds.width, 70) /// height of the cell
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false /// allow sticky header for dragging down the table view
        return flowLayout
    }
    
    required convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addArtistModal?.currentArtist = currentArtist
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setArtistId(artistId: String) {
        let artistService = sessionManager.artistService
        if let artist = artistService.getArtistForId(artistId) {
            addArtistModal.currentArtist = artist
        } else {
            artistService.processArtistData(artistId, completion: { (artist, success) in
                self.addArtistModal.currentArtist = artist
            })
        }
    }
    
    func closeTapped() {
        UIView.animateWithDuration(0.5, animations: {
            let centerX = self.closeButton.center.x
            self.closeButton.center = CGPointMake(centerX, 750)
        })

        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 0
        })
    
        delay(0.5, {
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    func setupLayout() {
        view.addConstraints([
            closeButton.al_width == screenWidth,
            closeButton.al_height == 55,
            closeButton.al_bottom == view.al_bottom
        ])
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func panHandler(sender: UIPanGestureRecognizer) {
        
        var center: CGPoint = view.center
        center.y = mainView.center.y // middle of the screen
        
        if (sender.state == UIGestureRecognizerState.Began) {
            self.lastLocation = mainView.center
        }
        
        if (mainView.center.x < 15) {
            UIView.animateWithDuration(0.2, animations: {
                self.mainView.transform = CGAffineTransformMakeRotation((15.0 * CGFloat(M_PI)) / 180.0)
            })
        }
        
        if self.mainView.center.x > UIScreen.mainScreen().bounds.width + 20 {
            UIView.animateWithDuration(0.2, animations: {
                self.animator?.removeBehavior(self.snap)
                self.mainView.transform = CGAffineTransformMakeRotation((350.0 * CGFloat(M_PI)) / 180.0)
            })
        }
        
        
        if (snap != nil) {
            animator?.removeBehavior(snap)
        }
        
        var translation: CGPoint = sender.translationInView(self.view)
        
        if(sender.state == UIGestureRecognizerState.Ended){
            snap = UISnapBehavior(item: mainView, snapToPoint: center)
            snap?.damping = 1.0
            animator?.addBehavior(snap)
        }
        mainView.center = CGPointMake(self.lastLocation!.x + translation.x, self.lastLocation!.y)
        
    }
}
