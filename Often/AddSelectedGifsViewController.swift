//
//  AddSelectedGifsViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddSelectedGifsViewController: OnboardingMediaItemPickerViewController {

    override init(viewModel: PackItemViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func nextButtonDidTap(sender: UIButton) {


    }

    override func skipButtonDidTap(sender: UIButton) {
        
    }


}