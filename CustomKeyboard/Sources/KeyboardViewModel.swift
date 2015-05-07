//
//  KeyboardViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class KeyboardViewModel: NSObject {
    var keyboardService: KeyboardService
    var delegate: KeyboardViewModelDelegate?
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
//        BaseURL = "https://drizzy-db-dev.firebaseio.com/v3/"
        self.keyboardService = KeyboardService(userId: "-Jl8teqNE9rtE5cwE_ZU",
            root: Firebase(url: BaseURL))

        super.init()
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        
        keyboardService.requestData({ data in
        
            self.delegate?.keyboardViewModelDidLoadData(self, data: data.values.array)
            
            if self.keyboardService.keyboards.count > 0 {
                if let lastKeyboardId = NSUserDefaults.standardUserDefaults().objectForKey("currentKeyboard") as? String, lastKeyboard = self.keyboardService.keyboards[lastKeyboardId] {
                    self.currentKeyboard = lastKeyboard
                } else {
                    self.currentKeyboard = self.keyboardService.keyboards.values.first
                }
                
                self.delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: self.currentKeyboard!)
            }
            completion?(true)
        })
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}