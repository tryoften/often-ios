//
//  SpellChecker.swift
//  Often
//
//  Created by Luc Succes on 10/27/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SpellChecker {
    private static var editDistanceMax: Int = 2
    private static var verbose: Int = 0
    
    struct DictionaryItem {
        var suggestions: [Int]
        var count: Int = 0
    }
    
    //Dictionary that contains both the original words and the deletes derived from them. A term might be both word and delete from another word at the same time.
    //For space reduction a item might be either of type dictionaryItem or Int.
    //A dictionaryItem is used for word, word/delete, and delete with multiple suggestions. Int is used for deletes with a single suggestion (the majority of entries).
    private var dictionary = [String: AnyObject]()
    
    //List of unique words. By using the suggestions (Int) as index for this list they are translated into the original string.
    private var wordList = [String]()
    
    //create a non-unique wordlist from sample text
    //language independent (e.g. works with Chinese characters)
    func parseWords(text: String) {
        
        // \w Alphanumeric characters (including non-latin characters, umlaut characters and digits) plus "_"
        // \d Digits
        // Provides identical results to Norvigs regex "[a-z]+" for latin characters, while additionally providing compatibility with non-latin characters
        var regex = NSRegularExpression(pattern:"[\\w-[\\d_]]+", options: .CaseInsensitive)
        regex.matchesInString(text, options: nil, range: Range(start: text.startIndex, end: text.endIndex))
    }
    
    public static var maxLength = 0
    
    //for every word there all deletes with an edit distance of 1..editDistanceMax created and added to the dictionary
    //every delete entry has a suggestions list, which points to the original term(s) it was created from
    //The dictionary may be dynamically updated (word frequency and new words) at any time by calling createDictionaryEntry
    func createDictionaryEntry(key: String, language: String) -> Bool {
        var result = false
//        var value: DictionaryItem?
        
        if let value = dictionary[language + key] {
            if let valueInt = value as? Int {
                
            }
        }
    }
}

struct SuggestItem: Equatable {
    var term: String
    var distance: Int = 0
    var count: Int = 0
}

func ==(lhs: SuggestItem, rhs: SuggestItem) -> Bool {
    return lhs.term == rhs.term
}
