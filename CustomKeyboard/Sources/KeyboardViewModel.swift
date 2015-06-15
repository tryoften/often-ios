//
//  KeyboardViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class KeyboardViewModel: NSObject, KeyboardServiceDelegate {
    var keyboardService: KeyboardService
    var delegate: KeyboardViewModelDelegate?
    var userDefaults: NSUserDefaults
    var keyboards: [Keyboard] {
        return self.keyboardService.keyboards.values.array
    }
    var currentKeyboard: Keyboard? {
        didSet {
            if let currentKeyboard = currentKeyboard {
                delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: currentKeyboard)
            }
        }
    }
    
    
    override init() {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!

        if let userId = userDefaults.objectForKey("userId") as? String {
            keyboardService = KeyboardService(userId: userId,
                root: Firebase(url: BaseURL))
        } else {
            keyboardService = KeyboardService(userId: nil, root: Firebase(url: BaseURL))
        }

        super.init()
        keyboardService.delegate = self
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        self.keyboardService.requestData({ data in
            completion?(true)
        })
    }
    
    // MARK: KeyboardServiceDelegate
    func serviceDataDidLoad(service: Service) {
        let keyboards = keyboardService.keyboards
        if keyboards.count > 0 {
            if let lastKeyboardId = NSUserDefaults.standardUserDefaults().objectForKey("currentKeyboard") as? String, lastKeyboard = keyboards[lastKeyboardId] {
                currentKeyboard = lastKeyboard
            } else {
                currentKeyboard = keyboards.values.first
            }
            
            delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: currentKeyboard!)
        }
        delegate?.keyboardViewModelDidLoadData(self, data: keyboards.values.array)
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}