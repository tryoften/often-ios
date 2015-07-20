//
//  VenmoServiceProvider.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoServiceProvider: ServiceProvider {
    override func provideSearchBarButton() -> ServiceProviderSearchBarButton {
        return VenmoSearchBarButton(frame: CGRectZero)
    }
    
    override func provideSupplementaryViewController() -> ServiceProviderSupplementaryViewController? {
        return VenmoSupplementaryViewController(textProcessor: textProcessor)
    }
}

class VenmoSupplementaryViewController: ServiceProviderSupplementaryViewController {
    var steps: [ServiceProviderSupplementaryViewController]
    var currentStep: ServiceProviderSupplementaryViewController

    override var supplementaryViewHeight: CGFloat {
        return currentStep.supplementaryViewHeight
    }
    
    override var searchBarPlaceholderText: String {
        return currentStep.searchBarPlaceholderText
    }
    
    override init(textProcessor: TextProcessingManager) {
        steps = []
        steps.append(VenmoContactsViewController(textProcessor: textProcessor))
        steps.append(VenmoMessageAmountViewController(textProcessor: textProcessor))
        
        currentStep = steps[0]
        super.init(textProcessor: textProcessor)
    }

    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(currentStep.view)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        currentStep.view.frame = view.bounds
    }
    
    func goToNextStep() {
    }
}