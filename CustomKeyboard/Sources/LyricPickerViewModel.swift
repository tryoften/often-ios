//
//  LyricPickerViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 2/19/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

class LyricPickerViewModel: NSObject {
    
    var trackService: TrackService
    weak var delegate: LyricPickerViewModelDelegate?
    var categories: [Category]?

    init(trackService: TrackService) {
        self.trackService = trackService
    }
    
    func getTrackForLyric(lyric: Lyric, completion: (track: Track) -> ()) {
        trackService.getTrackForLyric(lyric, persist: true, completion: completion)
    }
    
    func indexForCategory(category: Category) -> Int {
        if let categories = categories {
            for i in 0..<categories.count {
                if categories[i] == category {
                    return i
                }
            }
        }
        return -1
    }
    
    func numberOfSections() -> Int {
        if let categories = categories {
            return categories.count
        }
        return 0
    }
    
    func numberOfLyricsInSection(section: Int) -> Int {
        if let category = categories?[section] {
            return category.lyrics.count
        }
        return 0
    }
    
    func categoryAtIndex(index: Int) -> Category? {
        if let category = categories?[index] {
            return category
        }
        return nil
    }
    
    func sectionTitleAtIndex(index: Int) -> String {
        if let category = categories?[index] {
            return category.name
        }
        return ""
    }
    
    func lyricAtIndexInSection(index: Int, section: Int) -> Lyric? {
        if let category = categories?[section] {
            return category.lyrics[index]
        }
        return nil
    }
}

protocol LyricPickerViewModelDelegate: class {
    func lyricPickerViewModelDidLoadData(viewModel: LyricPickerViewModel, categories: [Category])
}

