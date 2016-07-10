//
//  BrowseCategoryPanelViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 6/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowseCategoryPanelViewController: UIViewController {

    private var categoryTableViewController: BrowseCategorySelectionTableViewController
    private var borderLine: UIView
    private var dismissalView: UIView
    private var navigationDismissalView: UIView
    weak var delegate: CategoryPanelControllable?
    var interactor: CategoryPanelInteractor?
    
    init() {
        categoryTableViewController = BrowseCategorySelectionTableViewController(style: .Plain)
        categoryTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = DarkGrey
        
        dismissalView = UIView()
        dismissalView.translatesAutoresizingMaskIntoConstraints = false
        dismissalView.backgroundColor = ClearColor
        
        navigationDismissalView = UIView()
        navigationDismissalView.translatesAutoresizingMaskIntoConstraints = false
        navigationDismissalView.backgroundColor = ClearColor
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = ClearColor
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: .Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            blurEffectView.frame = categoryTableViewController.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]

            categoryTableViewController.view.addSubview(blurEffectView)
            categoryTableViewController.view.sendSubviewToBack(blurEffectView)
        }
        
        view.addSubview(dismissalView)
        view.addSubview(categoryTableViewController.view)
        view.addSubview(navigationDismissalView)
        categoryTableViewController.view.addSubview(borderLine)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissalView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(CategoryCollectionViewController.cancelButtonDidTap)))
        dismissalView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(BrowseCategoryPanelViewController.sidePanelDidPan(_:))))
        navigationDismissalView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(CategoryCollectionViewController.cancelButtonDidTap)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonDidTap() {
        delegate?.categoryMenuButtonTapped()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sidePanelDidPan(recognizer: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        
        let translation = recognizer.translationInView(view)
        let horizontalMovement = abs(translation.x / view.bounds.width)
        let leftMovement = fmaxf(Float(horizontalMovement), 0.0)
        let leftMovementPercent = fminf(leftMovement, 1.0)
        let progress = CGFloat(leftMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch recognizer.state {
        case .Began:
            interactor.hasStarted = true
            dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            if interactor.shouldFinish  {
                interactor.finishInteractiveTransition()
                delegate?.categoryMenuButtonTapped()
            } else {
                interactor.cancelInteractiveTransition()
            }
        default:
            break
        }
    }
    
    func setupLayout() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        view.addConstraints([
            categoryTableViewController.view.al_top == view.al_top + NavigationBarHeight + StatusBarHeight,
            categoryTableViewController.view.al_left == view.al_left,
            categoryTableViewController.view.al_bottom == view.al_bottom,
            categoryTableViewController.view.al_width == screenWidth * 0.45,
            
            borderLine.al_left == view.al_left,
            borderLine.al_right == view.al_right,
            borderLine.al_top == view.al_top,
            borderLine.al_height == 0.5,
            
            dismissalView.al_left == view.al_left,
            dismissalView.al_right == view.al_right,
            dismissalView.al_bottom == view.al_bottom,
            dismissalView.al_top == view.al_top,
            
            navigationDismissalView.al_top == view.al_top - 66.0,
            navigationDismissalView.al_left == view.al_left,
            navigationDismissalView.al_right == view.al_right,
            navigationDismissalView.al_height == 66.0
        ])
    }
}

protocol CategoryPanelControllable: class {
    func categoryMenuButtonTapped()
}
