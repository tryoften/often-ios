//
//  KeyboardViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit
import RealmSwift

private var toolTipLogicOn = false // true: see real tool tip logic | false: see tool tips every time

class KeyboardViewModel: NSObject, KeyboardServiceDelegate, ArtistPickerCollectionViewDataSource {
    var keyboardService: KeyboardService
    var delegate: KeyboardViewModelDelegate?
    var userDefaults: NSUserDefaults
    var hasSeenToolTips: Bool?
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

        if let userId = userDefaults.objectForKey("userId") as? String {
            keyboardService = KeyboardService(userId: userId,
                root: Firebase(url: BaseURL), realm: realm)
        } else {
            // TODO(luc): get annonymous ID for the current session
            keyboardService = KeyboardService(userId: "annonymous", root: Firebase(url: BaseURL), realm: realm)
        }

        super.init()
        keyboardService.delegate = self
        
        
        // Tool Tips
        
        if toolTipLogicOn == true {
            if getHasSeenToolTips() == nil || getHasSeenToolTips() == false {
                setHasSeenToolTips(false) // If never been set or default false then they haven't seen it - init to false
            }
        } else {
            setHasSeenToolTips(false)
        }
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
            if let lastKeyboardId = NSUserDefaults.standardUserDefaults().objectForKey("currentKeyboard") as? String,
                lastKeyboard = keyboardService.keyboardWithId(lastKeyboardId) {
                currentKeyboard = lastKeyboard
            } else {
                currentKeyboard = keyboards.first
            }
            
            delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: currentKeyboard!)
        }
        delegate?.keyboardViewModelDidLoadData(self, data: keyboards)
    }
    
    func artistsDidUpdate(artists: [Artist]) {
    
    }
    
    func lyricsDidUpdate(lyrics: [Lyric]) {
        
    }
    
    // MARK: Tool Tip Methods
    
    /**
        Checks whether the current user has seen the Tool Tips for the keyboard
    
        :Returns: Boolean of whether or not the user has seen the Tool Tips - Nil if never set
    */
    func getHasSeenToolTips() -> Bool? {
        return userDefaults.objectForKey("toolTips") as? Bool
    }
    
    /**
        Set object for whether or not the user has seen the Tool Tips
    
        :param: bool What boolean you want to set the object to
    */
    func setHasSeenToolTips(bool: Bool) {
        userDefaults.setObject(bool, forKey: "toolTips")
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