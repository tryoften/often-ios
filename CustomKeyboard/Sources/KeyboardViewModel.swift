//
//  KeyboardViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class KeyboardViewModel: NSObject, KeyboardServiceDelegate, ArtistPickerCollectionViewDataSource {
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
            // TODO(luc): get annonymous ID for the current session
            keyboardService = KeyboardService(userId: "annonymous", root: Firebase(url: BaseURL))
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
    
    // MARK: ArtistPickerCollectionViewDataSource
    func numberOfItemsInArtistPicker(artistPicker: ArtistPickerCollectionViewController) -> Int {
        return keyboards.count
    }

    func artistPickerItemAtIndex(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Keyboard? {
        if index < keyboards.count {
            return keyboards[index]
        }
        return nil
    }

    func artistPickerShouldHaveCloseButton(artistPicker: ArtistPickerCollectionViewController) -> Bool {
        return true
    }
    
    func artistPickerItemAtIndexIsSelected(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Bool {
        return false
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}