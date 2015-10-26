//
//  LayoutConstants.swift
//  Surf
//
//  Created by Luc Succes on 7/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation


class LayoutConstants {
    class var landscapeRatio: CGFloat { return 2 }
    
    // side edges increase on 6 in portrait
    class var sideEdgesPortraitArray: [CGFloat] { return [3, 4] }
    class var sideEdgesPortraitWidthThreshholds: [CGFloat] { return [400] }
    class var sideEdgesLandscape: CGFloat { return 3 }
    
    // top edges decrease on various devices in portrait
    class var topEdgePortraitArray: [CGFloat] { return [12, 10, 8] }
    class var topEdgePortraitWidthThreshholds: [CGFloat] { return [350, 400] }
    class var topEdgeLandscape: CGFloat { return 6 }
    
    // keyboard area shrinks in size in landscape on 6 and 6+
    class var keyboardShrunkSizeArray: [CGFloat] { return [522, 524] }
    class var keyboardShrunkSizeWidthThreshholds: [CGFloat] { return [700] }
    class var keyboardShrunkSizeBaseWidthThreshhold: CGFloat { return 600 }
    
    // row gaps are weird on 6 in portrait
    class var rowGapPortraitArray: [CGFloat] { return [15, 11, 10] }
    class var rowGapPortraitThreshholds: [CGFloat] { return [350, 400] }
    class var rowGapPortraitLastRow: CGFloat { return 9 }
    class var rowGapPortraitLastRowIndex: Int { return 1 }
    class var rowGapLandscape: CGFloat { return 7 }
    
    // key gaps have weird and inconsistent rules
    class var keyGapPortraitNormal: CGFloat { return 6 }
    class var keyGapPortraitSmall: CGFloat { return 5 }
    class var keyGapPortraitNormalThreshhold: CGFloat { return 350 }
    class var keyGapPortraitUncompressThreshhold: CGFloat { return 350 }
    class var keyGapLandscapeNormal: CGFloat { return 6 }
    class var keyGapLandscapeSmall: CGFloat { return 5 }
    // TODO: 5.5 row gap on 5L
    // TODO: wider row gap on 6L
    class var keyCompressedThreshhold: Int { return 11 }
    
    // rows with two special keys on the side and characters in the middle (usually 3rd row)
    // TODO: these are not pixel-perfect, but should be correct within a few pixels
    // TODO: are there any "hidden constants" that would allow us to get rid of the multiplier? see: popup dimensions
    class var flexibleEndRowTotalWidthToKeyWidthMPortrait: CGFloat { return 1 }
    class var flexibleEndRowTotalWidthToKeyWidthCPortrait: CGFloat { return -14 }
    class var flexibleEndRowTotalWidthToKeyWidthMLandscape: CGFloat { return 0.9231 }
    class var flexibleEndRowTotalWidthToKeyWidthCLandscape: CGFloat { return -9.4615 }
    class var flexibleEndRowMinimumStandardCharacterWidth: CGFloat { return 7 }
    
    class var lastRowKeyGapPortrait: CGFloat { return 6 }
    class var lastRowKeyGapLandscapeArray: [CGFloat] { return [8, 7, 5] }
    class var lastRowKeyGapLandscapeWidthThreshholds: [CGFloat] { return [500, 700] }
    
    // TODO: approxmiate, but close enough
    class var lastRowPortraitFirstTwoButtonAreaWidthToKeyboardAreaWidth: CGFloat { return 0.24 }
    class var lastRowLandscapeFirstTwoButtonAreaWidthToKeyboardAreaWidth: CGFloat { return 0.19 }
    class var lastRowPortraitLastButtonAreaWidthToKeyboardAreaWidth: CGFloat { return 0.24 }
    class var lastRowLandscapeLastButtonAreaWidthToKeyboardAreaWidth: CGFloat { return 0.19 }
    class var micButtonPortraitWidthRatioToOtherSpecialButtons: CGFloat { return 1.0 }
    
    // TODO: not exactly precise
    class var popupGap: CGFloat { return 8 }
    class var popupWidthIncrement: CGFloat { return 26 }
    class var popupTotalHeightArray: [CGFloat] { return [102, 108] }
    class var popupTotalHeightDeviceWidthThreshholds: [CGFloat] { return [350] }
    
    class func sideEdgesPortrait(width: CGFloat) -> CGFloat {
        return self.findThreshhold(self.sideEdgesPortraitArray, threshholds: self.sideEdgesPortraitWidthThreshholds, measurement: width)
    }
    class func topEdgePortrait(width: CGFloat) -> CGFloat {
        return self.findThreshhold(self.topEdgePortraitArray, threshholds: self.topEdgePortraitWidthThreshholds, measurement: width)
    }
    class func rowGapPortrait(width: CGFloat) -> CGFloat {
        return self.findThreshhold(self.rowGapPortraitArray, threshholds: self.rowGapPortraitThreshholds, measurement: width)
    }
    
    class func rowGapPortraitLastRow(width: CGFloat) -> CGFloat {
        let index = self.findThreshholdIndex(self.rowGapPortraitThreshholds, measurement: width)
        if index == self.rowGapPortraitLastRowIndex {
            return self.rowGapPortraitLastRow
        }
        else {
            return self.rowGapPortraitArray[index]
        }
    }
    
    class func keyGapPortrait(width: CGFloat, rowCharacterCount: Int) -> CGFloat {
        let compressed = (rowCharacterCount >= self.keyCompressedThreshhold)
        if compressed {
            if width >= self.keyGapPortraitUncompressThreshhold {
                return self.keyGapPortraitNormal
            }
            else {
                return self.keyGapPortraitSmall
            }
        }
        else {
            return self.keyGapPortraitNormal
        }
    }
    class func keyGapLandscape(width: CGFloat, rowCharacterCount: Int) -> CGFloat {
        let compressed = (rowCharacterCount >= self.keyCompressedThreshhold)
        let shrunk = self.keyboardIsShrunk(width)
        if compressed || shrunk {
            return self.keyGapLandscapeSmall
        }
        else {
            return self.keyGapLandscapeNormal
        }
    }
    
    class func lastRowKeyGapLandscape(width: CGFloat) -> CGFloat {
        return self.findThreshhold(self.lastRowKeyGapLandscapeArray, threshholds: self.lastRowKeyGapLandscapeWidthThreshholds, measurement: width)
    }
    
    class func keyboardIsShrunk(width: CGFloat) -> Bool {
        let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        return (isPad ? false : width >= self.keyboardShrunkSizeBaseWidthThreshhold)
    }
    class func keyboardShrunkSize(width: CGFloat) -> CGFloat {
        let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        if isPad {
            return width
        }
        
        if width >= self.keyboardShrunkSizeBaseWidthThreshhold {
            return self.findThreshhold(self.keyboardShrunkSizeArray, threshholds: self.keyboardShrunkSizeWidthThreshholds, measurement: width)
        }
        else {
            return width
        }
    }
    
    class func popupTotalHeight(deviceWidth: CGFloat) -> CGFloat {
        return self.findThreshhold(self.popupTotalHeightArray, threshholds: self.popupTotalHeightDeviceWidthThreshholds, measurement: deviceWidth)
    }
    
    class func findThreshhold(elements: [CGFloat], threshholds: [CGFloat], measurement: CGFloat) -> CGFloat {
        assert(elements.count == threshholds.count + 1, "elements and threshholds do not match")
        return elements[self.findThreshholdIndex(threshholds, measurement: measurement)]
    }
    class func findThreshholdIndex(threshholds: [CGFloat], measurement: CGFloat) -> Int {
        for (i, threshhold) in Array(threshholds.reverse()).enumerate() {
            if measurement >= threshhold {
                let actualIndex = threshholds.count - i
                return actualIndex
            }
        }
        return 0
    }
}