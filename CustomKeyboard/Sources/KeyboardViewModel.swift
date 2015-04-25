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
        var BaseURL = "https://multi-keyboards.firebaseio.com/"
        BaseURL = "https://drizzy-db-dev.firebaseio.com/v3/"
        self.keyboardService = KeyboardService(userId: "-Jl8teqNE9rtE5cwE_ZU",
            root: Firebase(url: BaseURL))

        super.init()
    }
    
    func requestData(completion: (Bool) -> ()) {
        
        keyboardService.requestData({ data in
            
            if self.keyboardService.keyboards.count > 0 {
                
                // TODO(luc): persist the current keyboard ID on disk and read it back
                self.currentKeyboard = self.keyboardService.keyboards.values.first
            }
            self.delegate?.keyboardViewModelDidLoadData(self, data: data.values.array)
        })
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}