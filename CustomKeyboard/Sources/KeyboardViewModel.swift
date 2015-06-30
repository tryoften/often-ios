//
//  KeyboardViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit
import RealmSwift

class KeyboardViewModel: NSObject, KeyboardServiceDelegate, ArtistPickerCollectionViewDataSource {
    var keyboardService: KeyboardService
    var delegate: KeyboardViewModelDelegate?
    var userDefaults: NSUserDefaults
    var keyboards: [Keyboard] {
        return keyboardService.keyboards
    }
    var currentKeyboard: Keyboard? {
        didSet {
            if let currentKeyboard = currentKeyboard {
                delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: currentKeyboard)
            }
        }
    }
    
    init(realmPath: String? = nil) {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!

        var realm: Realm
        if let realmPath = realmPath {
            var fileManager = NSFileManager.defaultManager()
            println("readable: \(fileManager.isReadableFileAtPath(realmPath))")
            println("writable: \(fileManager.isWritableFileAtPath(realmPath))")
            realm = Realm(path: realmPath, readOnly: false, encryptionKey: nil, error: nil)!
        } else {
            realm = Realm()
        }
        
        
        if let userId = userDefaults.objectForKey("userId") as? String,
            let user = realm.objectForPrimaryKey(User.self, key: userId){
            keyboardService = KeyboardService(user: user,
                root: Firebase(url: BaseURL), realm: realm)
        } else {
            // TODO(luc): get annonymous ID for the current session
            let user = User()
            user.id = "anon"
            keyboardService = KeyboardService(user: user, root: Firebase(url: BaseURL), realm: realm)
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
            if let lastKeyboardId = keyboardService.currentKeyboardId,
                lastKeyboard = keyboardService.keyboardWithId(lastKeyboardId) {
                currentKeyboard = lastKeyboard
            } else {
                currentKeyboard = keyboards.first
            }
            
            delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: currentKeyboard!)
        }
        delegate?.keyboardViewModelDidLoadData(self, data: keyboards)
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
        if let currentKeyboardId = keyboardService.currentKeyboardId {
            var keyboard = keyboards[index]
            return keyboard.id == currentKeyboardId
        }
        return false
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}