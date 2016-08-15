//
//  OnboardingPackViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class OnboardingPackViewModel: PackItemViewModel {
    var selectedMediaItems: [MediaItem] = []

    override init(userId: String? = nil, packId: String = OftenPackID) {
        super.init(packId: packId)
    }

    func addMediaItem(mediaItem: MediaItem) {
        selectedMediaItems.append(mediaItem)
    }

    func removeMediaItem(mediaItem: MediaItem) {
        selectedMediaItems = selectedMediaItems.filter { $0 != mediaItem}
    }
}