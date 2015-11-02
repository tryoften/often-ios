//
//  SpellChecker.swift
//  Often
//
//  Copyright (C) 2015 Wolf Garbe
//  Version: 3.0
//  Author: Wolf Garbe <wolf.garbe@faroo.com>
//  Maintainer: Wolf Garbe <wolf.garbe@faroo.com>
//  URL: http://blog.faroo.com/2012/06/07/improved-edit-distance-based-spelling-correction/
//  Description: http://blog.faroo.com/2012/06/07/improved-edit-distance-based-spelling-correction/
//
//  License:
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License,
//  version 3.0 (LGPL-3.0) as published by the Free Software Foundation.
//  http://www.opensource.org/licenses/LGPL-3.0
//
//  Adapted to Swift by Luc Succes on 10/27/15.
//

import Foundation

class DictionaryItem: NSObject, NSCoding {
    var suggestions: [Int] = []
    var count: Int = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let suggestions = aDecoder.decodeObjectForKey("suggestions") as? [Int] {
            self.suggestions = suggestions
        }
        
        if let count = aDecoder.decodeObjectForKey("count") as? Int {
            self.count = count
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(count, forKey: "count")
        aCoder.encodeObject(suggestions, forKey: "suggestions")
    }
}


struct SuggestItem: Equatable {
    var term: String = ""
    var distance: Int = 0
    var count: Int = 0
}

func ==(lhs: SuggestItem, rhs: SuggestItem) -> Bool {
    return lhs.term == rhs.term
}

let SpellCheckerCachedDictionaryFilename = "spellDict.dat"

class SpellChecker: NSObject, NSCoding {
    private var editDistanceMax: Int = 2
    private var verbose: Int = 0
    
    static func spellCheckFromCachedDictionary(path: String) -> SpellChecker? {
        
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(path) {
            if let spellChecker = NSKeyedUnarchiver.unarchiveObjectWithData(NSData(contentsOfFile: path)!) as? SpellChecker {
                return spellChecker
            }
        }
        
        return nil
    }
    
    static func getFileURL(fileName: String) -> NSURL? {
        let manager = NSFileManager.defaultManager()
        do {
            let dirURL = try manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            return dirURL.URLByAppendingPathComponent(fileName)
        } catch {
        }
        return nil
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let dictionary = aDecoder.decodeObjectForKey("dictionary") as? [String: AnyObject] {
            self.dictionary = dictionary
        }
        
        if let wordList = aDecoder.decodeObjectForKey("wordList") as? [String] {
            self.wordList = wordList
        }
        
        if let maxLength = aDecoder.decodeObjectForKey("maxLength") as? Int {
            self.maxLength = maxLength
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(dictionary, forKey: "dictionary")
        aCoder.encodeObject(maxLength, forKey: "maxLength")
        aCoder.encodeObject(wordList, forKey: "wordList")
    }
    
    //Dictionary that contains both the original words and the deletes derived from them. A term might be both word and delete from another word at the same time.
    //For space reduction a item might be either of type dictionaryItem or Int.
    //A dictionaryItem is used for word, word/delete, and delete with multiple suggestions. Int is used for deletes with a single suggestion (the majority of entries).
    private var dictionary = [String: AnyObject]()
    
    //List of unique words. By using the suggestions (Int) as index for this list they are translated into the original string.
    private var wordList = [String]()
    
    //create a non-unique wordlist from sample text
    //language independent (e.g. works with Chinese characters)
    private func parseWords(text: String) -> [String] {
        
        // \w Alphanumeric characters (including non-latin characters, umlaut characters and digits) plus "_"
        // \d Digits
        // Provides identical results to Norvigs regex "[a-z]+" for latin characters, while additionally providing compatibility with non-latin characters
        do {
            let regex = try NSRegularExpression(pattern:"[\\w-[\\d_]]+", options: .CaseInsensitive)
            let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count))
            let nsText = text as NSString
            return results.map { nsText.substringWithRange($0.range)}
        } catch _ {
            
        }
        return []
    }
    
    internal var maxLength = 0
    
    func createDictionary(corpus: String, language: String) {
        
        let path = NSBundle.mainBundle().resourcePath! + "/" + corpus
        var wordCount = 0
        
        if let streamReader = StreamReader(path: path) {
            defer {
                streamReader.close()
            }
            
            while let line = streamReader.nextLine() {
                for key in parseWords(line) {
                    if createDictionaryEntry(key, language: language) {
                        wordCount++
                    }
                }
            }
        }
        
    }
    
    func saveDictionary() {
        if let filePath = SpellChecker.getFileURL(SpellCheckerCachedDictionaryFilename)?.path {
            print("Spell dictionary written to: \(filePath)")
            NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
        }
    }
    
    func correct(input: String, language: String) {
        let suggestions = lookup(input, language: language, editDistanceMax: editDistanceMax)
        
        for suggestion in suggestions {
            print(suggestion.term, " ", suggestion.distance, " ", suggestion.count)
        }
    }
    
    //for every word there all deletes with an edit distance of 1..editDistanceMax created and added to the dictionary
    //every delete entry has a suggestions list, which points to the original term(s) it was created from
    //The dictionary may be dynamically updated (word frequency and new words) at any time by calling createDictionaryEntry
    private func createDictionaryEntry(key: String, language: String) -> Bool {
        var result = false
        var newVal: DictionaryItem?
        
        if let value = dictionary[language + key] {
            if let valueInt = value as? Int {
                let item = DictionaryItem()
                item.suggestions.append(valueInt)
                
                dictionary[ language + key ] = item
                newVal = item
            }
                
            //already exists:
            //1. word appears several times
            //2. word1==deletes(word2)
            else if let valueDictItem = value as? DictionaryItem {
                newVal = valueDictItem
            }
            
            //prevent overflow
            if newVal?.count < Int.max {
                newVal?.count++
            }
        } else if wordList.count < Int.max {
            newVal = DictionaryItem()
            newVal?.count++
            
            dictionary[ language + key ] = newVal
            
            if key.characters.count > maxLength {
                maxLength = key.characters.count
            }
        }
        
        
        //edits/suggestions are created only once, no matter how often word occurs
        //edits/suggestions are created only as soon as the word occurs in the corpus,
        //even if the same term existed before in the dictionary as an edit from another word
        //a threshold might be specified, when a term occurs so frequently in the corpus that it is considered a valid word for spelling correction
        if newVal?.count == 1 {
            
            //word2index
            wordList.append(key)
            let keyInt = wordList.count - 1
            
            result = true
            
            //create deletes
            for delete in edits(key, editDistance: 0, deletes: Set<String>()) {
                
                if let value2 = dictionary[language+delete] {
                    
                    //already exists:
                    //1. word1==deletes(word2)
                    //2. deletes(word1)==deletes(word2)
                    //int or dictionaryItem? single delete existed before!
                    if let tmp = value2 as? Int {
                        var item = DictionaryItem()
                        item.suggestions.append(tmp)
                        
                        if !item.suggestions.contains(keyInt) {
                            addLowestDistance(&item, suggestion: key, suggestionInt: keyInt, delete: delete)
                        }
                        
                        dictionary[language + delete] = item
                        
                    } else if var dict = value2 as? DictionaryItem {
                        if !dict.suggestions.contains(keyInt) {
                            addLowestDistance(&dict, suggestion: key, suggestionInt: keyInt, delete: delete)
                        }
                    }
                } else {
                    dictionary[language + delete] = keyInt
                }
                
            }
        }
        
        return result
    }
    
    
    // shortcut to get length of a string
    private func l(string: String) -> Int {
        return string.characters.count
    }
    
    //inexpensive and language independent: only deletes, no transposes + replaces + inserts
    //replaces and inserts are expensive and language dependent (Chinese has 70,000 Unicode Han characters)
    private func edits(word: String, var editDistance: Int, var deletes: Set<String>) -> Set<String> {
        editDistance++
        
        if word.characters.count > 1 {
            for i in 0..<word.characters.count {
                var delete = word
                delete.removeAtIndex(delete.startIndex.advancedBy(i))
                
                if !deletes.contains(delete) {
                    deletes.insert(delete)
                    
                    if editDistance < editDistanceMax {
                        edits(delete, editDistance: editDistance, deletes: deletes)
                    }
                }
            }
        }
        
        return deletes
    }
    
    //save some time and space
    private func addLowestDistance(inout item: DictionaryItem, suggestion: String, suggestionInt: Int, delete: String) {
        //remove all existing suggestions of higher distance, if verbose<2
        //index2word
        if verbose < 2
            && item.suggestions.count > 0
            && wordList[item.suggestions[0]].length - delete.length > suggestion.length - delete.length {
                item.suggestions.removeAll()
        }
        
        //do not add suggestion of higher distance than existing, if verbose<2
        if verbose == 2
            || item.suggestions.count == 0
            || wordList[item.suggestions[0]].length - delete.length >= suggestion.length - delete.length {
                item.suggestions.append(suggestionInt)
        }
    }
    
    private func sort(var suggestions: [SuggestItem]) -> [SuggestItem] {
        if verbose < 2 {
            suggestions = suggestions.sort { (a, b) in
                return a.count - b.count < 0
            }
        } else {
            suggestions = suggestions.sort { (a, b) in
                return 2 * (a.distance - b.distance) - (a.count - b.count) < 0
            }
        }
        
        if verbose == 0 && suggestions.count > 1 {
            return Array(suggestions[0...1])
        } else {
            return suggestions
        }
    }
    
    func lookup(input: String, language: String, editDistanceMax: Int) -> [SuggestItem] {
        if input.length - editDistanceMax > maxLength {
            return [SuggestItem]()
        }
        
        var candidates = [String]()
        var set1 = Set<String>()
        
        var suggestions = [SuggestItem]()
        var set2 = Set<String>()
        
        //add original term
        candidates.append(input)
        
        while candidates.count > 0 {
            let candidate = candidates[0]
            candidates.removeFirst()
            
            if verbose < 2
                && suggestions.count > 0
                && input.length - candidate.length > suggestions[0].distance {
                    //TODO(luc): goto sort
                    return sort(suggestions)
            }
            
            //read candidate entry from dictionary
            if let value = dictionary[language + candidate] {
                var item = DictionaryItem()
                
                if let valueInt = value as? Int {
                    item.suggestions.append(valueInt)
                } else if let valueDict = value as? DictionaryItem {
                    item = valueDict
                }
                
                if (item.count > 0) && !set2.contains(candidate) {
                    set2.insert(candidate)
                    var suggestionItem = SuggestItem()
                    suggestionItem.term = candidate
                    suggestionItem.count = item.count
                    suggestionItem.distance = input.length - candidate.length
                    suggestions.append(suggestionItem)
                    
                    if verbose < 2 && input.length - candidate.length == 0 {
                        //TODO(luc): goto sort
                        return sort(suggestions)
                    }
                }

                for suggestionInt in item.suggestions {
                    let suggestion = wordList[suggestionInt]
                    
                    if !set2.contains(suggestion) {
                        set2.insert(suggestion)
                        
                        //True Damerau-Levenshtein Edit Distance: adjust distance, if both distances>0
                        //We allow simultaneous edits (deletes) of editDistanceMax on on both the dictionary and the input term.
                        //For replaces and adjacent transposes the resulting edit distance stays <= editDistanceMax.
                        //For inserts and deletes the resulting edit distance might exceed editDistanceMax.
                        //To prevent suggestions of a higher edit distance, we need to calculate the resulting edit distance, if there are simultaneous edits on both sides.
                        //Example: (bank==bnak and bank==bink, but bank!=kanb and bank!=xban and bank!=baxn for editDistanceMaxe=1)
                        //Two deletes on each side of a pair makes them all equal, but the first two pairs have edit distance=1, the others edit distance=2.
                        var distance = 0
                        
                        if suggestion != input {
                            if suggestion.length == candidate.length {
                                distance = input.length - candidate.length
                            }
                            
                            else if input.length == candidate.length {
                                distance = suggestion.length - candidate.length
                            }
                            
                            //common prefixes and suffixes are ignored, because this speeds up the Damerau-levenshtein-Distance calculation without changing it.
                            else {
                                var ii = 0, jj = 0

                                while ii < suggestion.length && ii < input.length && (suggestion[suggestion.startIndex.advancedBy(ii)] == input[input.startIndex.advancedBy(ii)]) {
                                    ii++
                                }
                                
                                while (jj < suggestion.length - ii) && (jj < input.length - ii)
                                    && (suggestion[suggestion.startIndex.advancedBy(suggestion.length - jj - 1)] == input[input.startIndex.advancedBy(input.length - jj - 1)]) {
                                    jj++
                                }
                                
                                if ii > 0 || jj > 0 {
                                    distance = DamerauLevenshteinDistance(suggestion[ii..<suggestion.length - jj], target: input[ii..<input.length - jj])
                                } else {
                                    distance = DamerauLevenshteinDistance(suggestion, target: input)
                                }
                            }
                        }
                        
                        //save some time.
                        //remove all existing suggestions of higher distance, if verbose<2
                        if (verbose < 2) && suggestions.count > 0 && (suggestions[0].distance > distance) {
                            suggestions.removeAll()
                        }
                        
                        //do not process higher distances than those already found, if verbose<2
                        if (verbose < 2) && suggestions.count > 0 && distance > suggestions[0].distance {
                            continue
                        }
                        
                        if distance <= editDistanceMax {
                            if let val = dictionary[language + suggestion] {
                                var suggestionItem = SuggestItem()
                                suggestionItem.term = suggestion
                                if let si = val as? DictionaryItem {
                                    suggestionItem.count = si.count
                                }
                                suggestionItem.distance = distance
                                suggestions.append(suggestionItem)
                            }
                        }
                    }
                }
            } // end for-in
            
            //add edits
            //derive edits (deletes) from candidate (input) and add them to candidates list
            //this is a recursive process until the maximum edit distance has been reached
            if input.length - candidate.length < editDistanceMax {
                
                if verbose < 2 && suggestions.count > 0 && input.length - candidate.length >= suggestions[0].distance {
                    continue
                }
                
                for var i = 0; i < candidate.length; i++ {
                    var delete = candidate
                    delete.removeAtIndex(delete.startIndex.advancedBy(i))
                    
                    if !set1.contains(delete) {
                        set1.insert(delete)
                        candidates.append(delete)
                    }
                }
            }

        }
        
        return sort(suggestions)
    }
    
    private func DamerauLevenshteinDistance(source: String, target: String) -> Int {
        let m: Int = l(source)
        let n: Int = l(target)
        var H = [[Int]]()
        
        for _ in 0..<m+2 {
            H.append(Array(count:n+2, repeatedValue: Int()))
        }
        
        let INF = m + n
        H[0][0] = INF
        
        for var i = 0; i <= m; i++ {
            H[i + 1][1] = i
            H[i + 1][0] = INF
        }
        
        for var j = 0; j <= n; j++ {
            H[1][j + 1] = j
            H[0][j + 1] = INF
        }
        
        var sortedDictionary = [Character: Int]()
        
        for char in (source + target).characters {
            if sortedDictionary[char] == nil {
                sortedDictionary[char] = 0
            }
        }
        
        for var i = 1; i <= m; i++ {
            var DB = 0
            
            for var j = 1; j <= n; j++ {
                guard let i1 = sortedDictionary[target[j - 1]] else {
                    continue
                }
                let j1 = DB
                
                if source[source.startIndex.advancedBy(i - 1)] == target[j - 1] {
                    H[i + 1][j + 1] = H[i][j]
                    DB = j
                } else {
                    H[i + 1][j + 1] = min(H[i][j], min(H[i + 1][j], H[i][j + 1])) + 1
                }
                
                let val2 = H[i1][j1] + (i - i1 - 1) + 1
                H[i + 1][j + 1] = min(H[i + 1][j + 1], val2 + (j - j1 - 1))
            }
            
            sortedDictionary[source[source.startIndex.advancedBy(i - 1)]] = i
        }
        return H[m + 1][n + 1]
    }
}