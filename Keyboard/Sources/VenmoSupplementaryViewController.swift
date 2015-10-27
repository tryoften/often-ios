//
//  VenmoSupplementaryViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/20/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoSupplementaryViewController: ServiceProviderSupplementaryViewController {
    var steps: [ServiceProviderSupplementaryViewController]
    var currentStep: ServiceProviderSupplementaryViewController
    
    private var stepIndex: Int
    
    override var supplementaryViewHeight: CGFloat {
        return currentStep.supplementaryViewHeight
    }
    
    override var searchBarPlaceholderText: String {
        return currentStep.searchBarPlaceholderText
    }
    
    override init(textProcessor: TextProcessingManager) {
        stepIndex = 0
        steps = []
        steps.append(VenmoContactsViewController(textProcessor: textProcessor))
        steps.append(VenmoMessageAmountViewController(textProcessor: textProcessor))
        
        currentStep = steps[stepIndex]
        super.init(textProcessor: textProcessor)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contactsCollectionViewDidSelectContact:", name: VenmoContactSelectedEvent, object: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(currentStep)
        view.addSubview(currentStep.view)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        currentStep.view.frame = view.bounds
    }
    
    func contactsCollectionViewDidSelectContact(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            _ = userInfo["name"] as? String,
            _ = userInfo["phone"] as? String {
                goToNextStep()
        }
    }
    
    func goToNextStep() {
        if ++stepIndex < steps.count {
            let nextStep = steps[stepIndex]
            
            addChildViewController(nextStep)
            view.insertSubview(nextStep.view, belowSubview: currentStep.view)
            
            UIView.animateWithDuration(0.3, animations: {
                self.currentStep.view.alpha = 0.0
            }, completion: { done in
                self.currentStep.view.removeFromSuperview()
                self.currentStep.removeFromParentViewController()
                
                self.currentStep = nextStep
            })
        }
    }
}