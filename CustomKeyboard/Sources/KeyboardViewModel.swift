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
    
    override init() {
        self.keyboardService = KeyboardService(userId: "-Jl8teqNE9rtE5cwE_ZU",
            root: Firebase(url: "https://multi-keyboards.firebaseio.com/"))

        super.init()
    }
    
    func requestData(completion: (Bool) -> ()) {
        
        keyboardService.requestData({ data in
            
        })
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
}