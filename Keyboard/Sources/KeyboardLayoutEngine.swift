//
//  KeyboardLayoutEngine.swift
//  Surf
//
//  Created by Luc Succes on 7/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

// handles the layout for the keyboard, including key spacing and arrangement
class KeyboardLayoutEngine: NSObject, KeyboardKeyProtocol {
    
    class var shouldPoolKeys: Bool { get { return true }}
    
    var layoutConstants: LayoutConstants.Type
    
    var model: KeyboardLayout
    unowned var superview: UIView
    var modelToView: [KeyboardKey : KeyboardKeyButton] = [:]
    var viewToModel: [KeyboardKeyButton : KeyboardKey] = [:]
    
    var keyPool: [KeyboardKeyButton] = []
    var nonPooledMap: [String: KeyboardKeyButton] = [:]
    var sizeToKeyMap: [CGSize: [KeyboardKeyButton]] = [:]
    var shapePool: [String: Shape] = [:]
    
    required init(model: KeyboardLayout, superview: UIView, layoutConstants: LayoutConstants.Type) {
        self.layoutConstants = layoutConstants
        
        self.model = model
        self.superview = superview
    }
    
    func viewForKey(model: KeyboardKey) -> KeyboardKeyButton? {
        return self.modelToView[model]
    }
    
    func keyForView(key: KeyboardKeyButton) -> KeyboardKey? {
        return self.viewToModel[key]
    }
    
    func layoutKeys(pageNum: Int, uppercase: Bool, characterUppercase: Bool, shiftState: ShiftState) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // pre-allocate all keys if no cache
        if !self.dynamicType.shouldPoolKeys {
            if self.keyPool.isEmpty {
                for p in 0..<self.model.pages.count {
                    self.positionKeys(p)
                }
                self.updateKeyCaps(true, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: shiftState)
            }
        }
        
        self.positionKeys(pageNum)
        
        // reset state
        for (p, page) in self.model.pages.enumerate() {
            for (_, row) in page.rows.enumerate() {
                for (_, key) in row.enumerate() {
                    if let keyView = self.modelToView[key] {
                        keyView.hidePopup()
                        keyView.highlighted = false
                        keyView.hidden = p != pageNum && !key.isModifier
                    }
                }
            }
        }
        
        if self.dynamicType.shouldPoolKeys {
            self.updateKeyCaps(true, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: shiftState)
        }
        
        CATransaction.commit()
    }
    
    /**
        Positions keys for a page number
        - parameter pageNum: the page index
    */
    func positionKeys(pageNum: Int) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let setupKey = { (view: KeyboardKeyButton, model: KeyboardKey, frame: CGRect) -> Void in
            view.frame = frame
            self.modelToView[model] = view
            self.viewToModel[view] = model
        }
        
        if var keyMap = self.generateKeyFrames(self.model, bounds: self.superview.bounds, page: pageNum) {
            if self.dynamicType.shouldPoolKeys {
                self.modelToView.removeAll(keepCapacity: true)
                self.viewToModel.removeAll(keepCapacity: true)
                
                self.resetKeyPool()
                
                var foundCachedKeys = [KeyboardKey]()
                
                // pass 1: reuse any keys that match the required size
                for (key, frame) in keyMap {
                    if let keyView = self.pooledKey(key: key, model: self.model, frame: frame) {
                        foundCachedKeys.append(key)
                        setupKey(keyView, key, frame)
                    }
                }
                
                foundCachedKeys.map {
                    keyMap.removeValueForKey($0)
                }
                
                // pass 2: fill in the blanks
                for (key, frame) in keyMap {
                    let keyView = self.generateKey()
                    setupKey(keyView, key, frame)
                }
            }
            else {
                for (key, frame) in keyMap {
                    if let keyView = self.pooledKey(key: key, model: self.model, frame: frame) {
                        setupKey(keyView, key, frame)
                    }
                }
            }
        }
        
        CATransaction.commit()
    }
    
    // on fullReset, we update the keys with shapes, images, etc. as if from scratch; otherwise, just update the text
    // WARNING: if key cache is disabled, DO NOT CALL WITH fullReset MORE THAN ONCE
    func updateKeyCaps(fullReset: Bool, uppercase: Bool, characterUppercase: Bool, shiftState: ShiftState) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for (model, key) in self.modelToView {
            self.updateKeyCap(key, model: model, fullReset: fullReset, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: shiftState)
        }
        
        CATransaction.commit()
    }
    
    func updateKeyCap(key: KeyboardKeyButton, model: KeyboardKey, fullReset: Bool, uppercase: Bool, characterUppercase: Bool, shiftState: ShiftState) {
        key.key = model
    }
    
    // TODO: avoid array copies
    // TODO: sizes stored not rounded?
    
    ///////////////////////////
    // KEY POOLING FUNCTIONS //
    ///////////////////////////
    
    // if pool is disabled, always returns a unique key view for the corresponding key model
    func pooledKey(key aKey: KeyboardKey, model: KeyboardLayout, frame: CGRect) -> KeyboardKeyButton? {
        if !self.dynamicType.shouldPoolKeys {
            var p: Int!
            var r: Int!
            var k: Int!
            
            // TODO: O(N^2) in terms of total # of keys since pooledKey is called for each key, but probably doesn't matter
            var foundKey: Bool = false
            for (pp, page) in model.pages.enumerate() {
                for (rr, row) in page.rows.enumerate() {
                    for (kk, key) in row.enumerate() {
                        if key == aKey {
                            p = pp
                            r = rr
                            k = kk
                            foundKey = true
                        }
                        if foundKey {
                            break
                        }
                    }
                    if foundKey {
                        break
                    }
                }
                if foundKey {
                    break
                }
            }
            
            let id = "p\(p)r\(r)k\(k)"
            if let key = self.nonPooledMap[id] {
                return key
            }
            else {
                let key = generateKey()
                self.nonPooledMap[id] = key
                return key
            }
        }
        else {
            if var keyArray = self.sizeToKeyMap[frame.size] {
                if let key = keyArray.last {
                    if keyArray.count == 1 {
                        self.sizeToKeyMap.removeValueForKey(frame.size)
                    }
                    else {
                        keyArray.removeLast()
                        self.sizeToKeyMap[frame.size] = keyArray
                    }
                    return key
                }
                else {
                    return nil
                }
                
            }
            else {
                return nil
            }
        }
    }
    
    func createNewKey() -> KeyboardKeyButton {
        return KeyboardKeyButton()
    }
    
    // if pool is disabled, always generates a new key
    func generateKey() -> KeyboardKeyButton {
        let createAndSetupNewKey = { () -> KeyboardKeyButton in
            let keyView = self.createNewKey()
            
            keyView.enabled = true
            keyView.delegate = self
            
            self.superview.addSubview(keyView)
            
            self.keyPool.append(keyView)
            
            return keyView
        }
        
        if self.dynamicType.shouldPoolKeys {
            if !self.sizeToKeyMap.isEmpty {
                var (size, keyArray) = self.sizeToKeyMap[self.sizeToKeyMap.startIndex]
                
                if let key = keyArray.last {
                    if keyArray.count == 1 {
                        self.sizeToKeyMap.removeValueForKey(size)
                    }
                    else {
                        keyArray.removeLast()
                        self.sizeToKeyMap[size] = keyArray
                    }
                    
                    return key
                }
                else {
                    return createAndSetupNewKey()
                }
            }
            else {
                return createAndSetupNewKey()
            }
        }
        else {
            return createAndSetupNewKey()
        }
    }
    
    // if pool is disabled, doesn't do anything
    func resetKeyPool() {
        if self.dynamicType.shouldPoolKeys {
            self.sizeToKeyMap.removeAll(keepCapacity: true)
            
            for key in self.keyPool {
                if var keyArray = self.sizeToKeyMap[key.frame.size] {
                    keyArray.append(key)
                    self.sizeToKeyMap[key.frame.size] = keyArray
                }
                else {
                    var keyArray = [KeyboardKeyButton]()
                    keyArray.append(key)
                    self.sizeToKeyMap[key.frame.size] = keyArray
                }
                key.hidden = true
            }
        }
    }
    
    // TODO: no support for more than one of the same shape
    // if pool disabled, always returns new shape
    func getShape(shapeClass: Shape.Type) -> Shape {
        let className = NSStringFromClass(shapeClass)
        
        if self.dynamicType.shouldPoolKeys {
            if let shape = self.shapePool[className] {
                return shape
            }
            else {
                let shape = shapeClass.init(frame: CGRectZero)
                self.shapePool[className] = shape
                return shape
            }
        }
        else {
            return shapeClass.init(frame: CGRectZero)
        }
    }
    
    //////////////////////
    // LAYOUT FUNCTIONS //
    //////////////////////
    
    func rounded(measurement: CGFloat) -> CGFloat {
        return round(measurement * UIScreen.mainScreen().scale) / UIScreen.mainScreen().scale
    }
    
    func generateKeyFrames(model: KeyboardLayout, bounds: CGRect, page pageToLayout: Int) -> [KeyboardKey: CGRect]? {
        if bounds.height == 0 || bounds.width == 0 {
            return nil
        }
        
        var keyMap = [KeyboardKey: CGRect]()
        
        let isLandscape: Bool = {
            let boundsRatio = bounds.width / bounds.height
            return (boundsRatio >= self.layoutConstants.landscapeRatio)
            }()
        
        var sideEdges = (isLandscape ? self.layoutConstants.sideEdgesLandscape : self.layoutConstants.sideEdgesPortrait(bounds.width))
        let bottomEdge = sideEdges
        
        let normalKeyboardSize = bounds.width - CGFloat(2) * sideEdges
        let shrunkKeyboardSize = self.layoutConstants.keyboardShrunkSize(normalKeyboardSize)
        
        sideEdges += ((normalKeyboardSize - shrunkKeyboardSize) / CGFloat(2))
        
        let topEdge: CGFloat = (isLandscape ? self.layoutConstants.topEdgeLandscape : self.layoutConstants.topEdgePortrait(bounds.width))
        
        let rowGap: CGFloat = (isLandscape ? self.layoutConstants.rowGapLandscape : self.layoutConstants.rowGapPortrait(bounds.width))
        let lastRowGap: CGFloat = (isLandscape ? rowGap : self.layoutConstants.rowGapPortraitLastRow(bounds.width))
        
        let flexibleEndRowM = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMPortrait)
        let flexibleEndRowC = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCPortrait)
        
        let lastRowLeftSideRatio = (isLandscape ? self.layoutConstants.lastRowLandscapeFirstTwoButtonAreaWidthToKeyboardAreaWidth : self.layoutConstants.lastRowPortraitFirstTwoButtonAreaWidthToKeyboardAreaWidth)
        let lastRowRightSideRatio = (isLandscape ? self.layoutConstants.lastRowLandscapeLastButtonAreaWidthToKeyboardAreaWidth : self.layoutConstants.lastRowPortraitLastButtonAreaWidthToKeyboardAreaWidth)
        let lastRowKeyGap = (isLandscape ? self.layoutConstants.lastRowKeyGapLandscape(bounds.width) : self.layoutConstants.lastRowKeyGapPortrait)
        
        for (p, page) in model.pages.enumerate() {
            if p != pageToLayout {
                continue
            }
            
            let numRows = page.rows.count
            
            let mostKeysInRow: Int = {
                var currentMax: Int = 0
                for (i, row) in page.rows.enumerate() {
                    currentMax = max(currentMax, row.count)
                }
                return currentMax
                }()
            
            let rowGapTotal = CGFloat(numRows - 1 - 1) * rowGap + lastRowGap
            
            let keyGap: CGFloat = (isLandscape ? self.layoutConstants.keyGapLandscape(bounds.width, rowCharacterCount: mostKeysInRow) : self.layoutConstants.keyGapPortrait(bounds.width, rowCharacterCount: mostKeysInRow))
            
            let keyHeight: CGFloat = {
                let totalGaps = bottomEdge + topEdge + rowGapTotal
                let returnHeight = (bounds.height - totalGaps) / CGFloat(numRows)
                return self.rounded(returnHeight)
                }()
            
            let letterKeyWidth: CGFloat = {
                let totalGaps = (sideEdges * CGFloat(2)) + (keyGap * CGFloat(mostKeysInRow - 1))
                let returnWidth = (bounds.width - totalGaps) / CGFloat(mostKeysInRow)
                return self.rounded(returnWidth)
                }()
            
            let processRow = { (row: [KeyboardKey], frames: [CGRect], inout map: [KeyboardKey: CGRect]) -> Void in
                assert(row.count == frames.count, "row and frames don't match")
                for (k, key) in row.enumerate() {
                    map[key] = frames[k]
                }
            }
            
            for (r, row) in page.rows.enumerate() {
                let rowGapCurrentTotal = (r == page.rows.count - 1 ? rowGapTotal : CGFloat(r) * rowGap)
                let frame = CGRectMake(rounded(sideEdges), rounded(topEdge + (CGFloat(r) * keyHeight) + rowGapCurrentTotal), rounded(bounds.width - CGFloat(2) * sideEdges), rounded(keyHeight))
                
                var frames: [CGRect]!
                
                // basic character row: only typable characters
                if self.characterRowHeuristic(row) {
                    frames = self.layoutCharacterRow(row, keyWidth: letterKeyWidth, gapWidth: keyGap, frame: frame)
                }
                    
                    // character row with side buttons: shift, backspace, etc.
                else if self.doubleSidedRowHeuristic(row) {
                    frames = self.layoutCharacterWithSidesRow(row, frame: frame, isLandscape: isLandscape, keyWidth: letterKeyWidth, keyGap: keyGap)
                }
                    
                    // bottom row with things like space, return, etc.
                else {
                    frames = self.layoutSpecialKeysRow(row, keyWidth: letterKeyWidth, gapWidth: lastRowKeyGap, leftSideRatio: lastRowLeftSideRatio, rightSideRatio: lastRowRightSideRatio, micButtonRatio: self.layoutConstants.micButtonPortraitWidthRatioToOtherSpecialButtons, isLandscape: isLandscape, frame: frame)
                }
                
                processRow(row, frames, &keyMap)
            }
        }
        
        return keyMap
    }
    
    func characterRowHeuristic(row: [KeyboardKey]) -> Bool {
        return (row.count >= 1 && row[0].isCharacter)
    }
    
    func doubleSidedRowHeuristic(row: [KeyboardKey]) -> Bool {
        return (row.count >= 3 && !row[0].isCharacter && row[1].isCharacter)
    }
    
    func layoutCharacterRow(row: [KeyboardKey], keyWidth: CGFloat, gapWidth: CGFloat, frame: CGRect) -> [CGRect] {
        var frames = [CGRect]()
        
        let keySpace = CGFloat(row.count) * keyWidth + CGFloat(row.count - 1) * gapWidth
        var actualGapWidth = gapWidth
        var sideSpace = (frame.width - keySpace) / CGFloat(2)
        
        // TODO: port this to the other layout functions
        // avoiding rounding errors
        if sideSpace < 0 {
            sideSpace = 0
            actualGapWidth = (frame.width - (CGFloat(row.count) * keyWidth)) / CGFloat(row.count - 1)
        }
        
        var currentOrigin = frame.origin.x + sideSpace
        
        for (k, key) in row.enumerate() {
            let roundedOrigin = rounded(currentOrigin)
            
            // avoiding rounding errors
            if roundedOrigin + keyWidth > frame.origin.x + frame.width {
                frames.append(CGRectMake(rounded(frame.origin.x + frame.width - keyWidth), frame.origin.y, keyWidth, frame.height))
            }
            else {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, keyWidth, frame.height))
            }
            
            currentOrigin += (keyWidth + actualGapWidth)
        }
        
        return frames
    }
    
    // TODO: pass in actual widths instead
    func layoutCharacterWithSidesRow(row: [KeyboardKey], frame: CGRect, isLandscape: Bool, keyWidth: CGFloat, keyGap: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        
        let standardFullKeyCount = Int(self.layoutConstants.keyCompressedThreshhold) - 1
        let standardGap = (isLandscape ? self.layoutConstants.keyGapLandscape : self.layoutConstants.keyGapPortrait)(frame.width, rowCharacterCount: standardFullKeyCount)
        let sideEdges = (isLandscape ? self.layoutConstants.sideEdgesLandscape : self.layoutConstants.sideEdgesPortrait(frame.width))
        var standardKeyWidth = (frame.width - sideEdges - (standardGap * CGFloat(standardFullKeyCount - 1)) - sideEdges)
        standardKeyWidth /= CGFloat(standardFullKeyCount)
        let standardKeyCount = self.layoutConstants.flexibleEndRowMinimumStandardCharacterWidth
        
        let standardWidth = CGFloat(standardKeyWidth * standardKeyCount + standardGap * (standardKeyCount - 1))
        let currentWidth = CGFloat(row.count - 2) * keyWidth + CGFloat(row.count - 3) * keyGap
        
        let isStandardWidth = (currentWidth < standardWidth)
        let actualWidth = (isStandardWidth ? standardWidth : currentWidth)
        let actualGap = (isStandardWidth ? standardGap : keyGap)
        let actualKeyWidth = (actualWidth - CGFloat(row.count - 3) * actualGap) / CGFloat(row.count - 2)
        
        let sideSpace = (frame.width - actualWidth) / CGFloat(2)
        
        let m = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMPortrait)
        let c = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCPortrait)
        
        var specialCharacterWidth = sideSpace * m + c
        specialCharacterWidth = max(specialCharacterWidth, keyWidth)
        specialCharacterWidth = rounded(specialCharacterWidth)
        let specialCharacterGap = sideSpace - specialCharacterWidth
        
        var currentOrigin = frame.origin.x
        for (k, key) in row.enumerate() {
            if k == 0 {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, specialCharacterWidth, frame.height))
                currentOrigin += (specialCharacterWidth + specialCharacterGap)
            }
            else if k == row.count - 1 {
                currentOrigin += specialCharacterGap
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, specialCharacterWidth, frame.height))
                currentOrigin += specialCharacterWidth
            }
            else {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, actualKeyWidth, frame.height))
                if k == row.count - 2 {
                    currentOrigin += (actualKeyWidth)
                }
                else {
                    currentOrigin += (actualKeyWidth + keyGap)
                }
            }
        }
        
        return frames
    }
    
    func layoutSpecialKeysRow(row: [KeyboardKey], keyWidth: CGFloat, gapWidth: CGFloat, leftSideRatio: CGFloat, rightSideRatio: CGFloat, micButtonRatio: CGFloat, isLandscape: Bool, frame: CGRect) -> [CGRect] {
        var frames = [CGRect]()
        
        var keysBeforeSpace = 0
        var keysAfterSpace = 0
        var reachedSpace = false
        for (k, key) in row.enumerate() {
            if key.isSpace {
                reachedSpace = true
            }
            else {
                if !reachedSpace {
                    keysBeforeSpace += 1
                }
                else {
                    keysAfterSpace += 1
                }
            }
        }
        
        assert(keysBeforeSpace <= 3, "invalid number of keys before space (only max 3 currently supported)")
        
        let hasButtonInMicButtonPosition = (keysBeforeSpace == 3)
        
        var leftSideAreaWidth = frame.width * leftSideRatio
        let rightSideAreaWidth = frame.width * rightSideRatio
        var leftButtonWidth = (leftSideAreaWidth - (gapWidth * CGFloat(2 - 1))) / CGFloat(2)
        leftButtonWidth = rounded(leftButtonWidth)
        var rightButtonWidth = (rightSideAreaWidth - (gapWidth * CGFloat(keysAfterSpace - 1))) / CGFloat(keysAfterSpace)
        rightButtonWidth = rounded(rightButtonWidth)
        
        let micButtonWidth = (isLandscape ? leftButtonWidth : leftButtonWidth * micButtonRatio)
        
        // special case for mic button
        if hasButtonInMicButtonPosition {
            leftSideAreaWidth = leftSideAreaWidth + gapWidth + micButtonWidth
        }
        
        var spaceWidth = frame.width - leftSideAreaWidth - rightSideAreaWidth - gapWidth * CGFloat(2)
        spaceWidth = rounded(spaceWidth)
        
        var currentOrigin = frame.origin.x
        var beforeSpace: Bool = true
        for (k, key) in row.enumerate() {
            if key.isSpace {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, spaceWidth, frame.height))
                currentOrigin += (spaceWidth + gapWidth)
                beforeSpace = false
            }
            else if beforeSpace {
                if hasButtonInMicButtonPosition && k == 2 { //mic button position
                    frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, micButtonWidth, frame.height))
                    currentOrigin += (micButtonWidth + gapWidth)
                }
                else {
                    frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, leftButtonWidth, frame.height))
                    currentOrigin += (leftButtonWidth + gapWidth)
                }
            }
            else {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, rightButtonWidth, frame.height))
                currentOrigin += (rightButtonWidth + gapWidth)
            }
        }
        
        return frames
    }
    
    func frameForPopup(key: KeyboardKeyButton, direction: Direction) -> CGRect {
        let actualScreenWidth = (UIScreen.mainScreen().nativeBounds.size.width / UIScreen.mainScreen().nativeScale)
        let totalHeight = self.layoutConstants.popupTotalHeight(actualScreenWidth)
        
        let popupWidth = key.bounds.width + self.layoutConstants.popupWidthIncrement
        let popupHeight = totalHeight - self.layoutConstants.popupGap - key.bounds.height
        let popupCenterY = 0
        
        return CGRectMake((key.bounds.width - popupWidth) / CGFloat(2), -popupHeight - self.layoutConstants.popupGap, popupWidth, popupHeight)
    }
    
    func willShowPopup(key: KeyboardKeyButton, direction: Direction) {
        // TODO: actual numbers, not standins
        if let popup = key.popup {
            // TODO: total hack
            let actualSuperview = (self.superview.superview != nil ? self.superview.superview! : self.superview)
            
            var localFrame = actualSuperview.convertRect(popup.frame, fromView: popup.superview)
            
            if localFrame.origin.y < 3 {
                localFrame.origin.y = 3
                
                key.background.attached = Direction.Down
                key.connector?.startDir = Direction.Down
                key.background.hideDirectionIsOpposite = true
            }
            else {
                // TODO: this needs to be reset somewhere
                key.background.hideDirectionIsOpposite = false
            }
            
            if localFrame.origin.x < 3 {
                localFrame.origin.x = key.frame.origin.x
            }
            
            if localFrame.origin.x + localFrame.width > superview.bounds.width - 3 {
                localFrame.origin.x = key.frame.origin.x + key.frame.width - localFrame.width
            }
            
            popup.frame = actualSuperview.convertRect(localFrame, toView: popup.superview)
        }
    }
    
    func willHidePopup(key: KeyboardKeyButton) {
    }
}
