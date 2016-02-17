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
//  swiftlint:disable function_body_length

import Foundation
import RealmSwift
import Realm

class DictionaryItem: Object {
    dynamic var id: String = ""
    dynamic var count: Int = 0
    let suggestions = List<Term>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

struct SuggestItem: Equatable {
    var term: String = ""
    var distance: Int = 0
    var count: Int = 0
    var isInput: Bool = false
}

func ==(lhs: SuggestItem, rhs: SuggestItem) -> Bool {
    return lhs.term == rhs.term
}

let SpellCheckerCachedDictionaryFilename = "db.realm"
let SpellCheckerMaxLengthKey = "SpellChecker.maxLength"

class SpellChecker {
    private var editDistanceMax: Int = 2
    private var verbose: Int = 0
    private var userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
    private var realm: Realm?
    
    //Dictionary that contains both the original words and the deletes derived from them. A term might be both word and delete from another word at the same time.
    //For space reduction a item might be either of type dictionaryItem or Int.
    //A dictionaryItem is used for word, word/delete, and delete with multiple suggestions. Int is used for deletes with a single suggestion (the majority of entries).
    private var dictionary: CachedDictionary<NSString, DictionaryItem>
    
    //List of unique words. By using the suggestions (Int) as index for this list they are translated into the original string.
    private var wordList: CachedArray<Term>
    
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
    
    internal var maxLength = 0 {
        didSet {
            userDefaults.setInteger(maxLength, forKey: SpellCheckerMaxLengthKey)
        }
    }
    
    init() {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let directory: NSURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let realmPath = directory.URLByAppendingPathComponent(SpellCheckerCachedDictionaryFilename).path!
        
        if !fileManager.fileExistsAtPath(realmPath) {
            let bundledDB = NSBundle.mainBundle().resourcePath! + "/" + SpellCheckerCachedDictionaryFilename
            do {
                try fileManager.copyItemAtPath(bundledDB, toPath: realmPath)
            } catch let error {
                print("Copying dictionary database failed ", error)
            }
        }
    
        RLMRealm.setDefaultRealmPath(realmPath)
        maxLength = userDefaults.integerForKey(SpellCheckerMaxLengthKey)
        
        do {
            if fileManager.isWritableFileAtPath(realmPath) {
                realm = try Realm()
            } else {
                realm = try Realm(path: realmPath, readOnly: true)
            }
            dictionary = CachedDictionary<NSString, DictionaryItem>(realm: realm)
            wordList = CachedArray<Term>(realm: realm)
            return
        } catch {
            print("failed to open realm db")
        }
        
        dictionary = CachedDictionary<NSString, DictionaryItem>(realm: nil)
        wordList = CachedArray<Term>(realm: nil)
    }
    
    func createDictionary(corpus: String, language: String) {
        
        let path = NSBundle.mainBundle().resourcePath! + "/" + corpus
        var wordCount = 0
        
        if let streamReader = StreamReader(path: path) {
            defer {
                streamReader.close()
            }
            
            realm?.beginWrite()
            while let line = streamReader.nextLine() {
                autoreleasepool {
                    for key in parseWords(line) {
                        if createDictionaryEntry(key, language: language) {
                            wordCount++
                        }
                    }
                }
            }
            do {
                try realm?.commitWrite()
            } catch {
                print("realm: could not write data")
            }
        }
    }
    
    func saveDictionary() {
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
    func createDictionaryEntry(key: String, language: String) -> Bool {
        var result = false
        var newVal: DictionaryItem?
        
        
        if let value = dictionary[language + key] {
            newVal = value
            
            //prevent overflow
            value.count++
            print(key, " ", value.count)
        } else if wordList.count < Int.max {
            newVal = DictionaryItem()
            newVal!.id = language + key
            newVal!.count++

            dictionary.setObject(newVal!, forKey: language + key)
            
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
            let term = Term()
            term.term = key
            wordList.append(term)
            
            
            let keyInt = wordList.count - 1
            term.id = String(keyInt)
            
            realm?.add(term, update: true)
            
            result = true
            
            //create deletes
            for delete in edits(key, editDistance: 0, deletes: Set<String>()) {
                
                if var value2 = dictionary[language+delete] {
                    //already exists:
                    //1. word1==deletes(word2)
                    //2. deletes(word1)==deletes(word2)
                    //int or dictionaryItem? single delete existed before!
                    if !value2.suggestions.contains(term) {
                        addLowestDistance(&value2, suggestion: term, delete: delete)
                    }
    
                } else {
                    let item = DictionaryItem()
                    item.id = language + delete
                    item.suggestions.append(term)
                    dictionary.setObject(item, forKey: language + delete)
                }
                
            }
        }
        
        return result
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
    private func addLowestDistance(inout item: DictionaryItem, suggestion: Term, delete: String) {
        //remove all existing suggestions of higher distance, if verbose<2
        //index2word
        guard item.suggestions.count != 0 else {
            return
        }
        let word = suggestion.term
        
        if verbose < 2
            && item.suggestions.count > 0
            && word.length - delete.length > suggestion.length - delete.length {
                item.suggestions.removeAll()
        }
        
        //do not add suggestion of higher distance than existing, if verbose<2
        if verbose == 2
            || item.suggestions.count == 0
            || word.length - delete.length >= suggestion.length - delete.length {
                item.suggestions.append(suggestion)
        }
        
        realm?.add(item, update: true)
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
        var candidates = [Term]()
        var set1 = Set<Term>()
        
        var suggestions = [SuggestItem]()
        var set2 = Set<Term>()
        
        //add original term
        candidates.append(Term(string: input))
        
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
            if let item = dictionary[language + candidate.term] {

                if item.count > 0 {
                    set2.insert(candidate)
                    var suggestionItem = SuggestItem()
                    suggestionItem.term = candidate.term
                    suggestionItem.count = item.count
                    suggestionItem.distance = input.length - candidate.length
                    suggestions.append(suggestionItem)
                    
                    if verbose < 2 && input.length - candidate.length == 0 {
                        //TODO(luc): goto sort
                        return sort(suggestions)
                    }
                }

                for suggestion in item.suggestions {
                    let term = suggestion.term
                    
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
                            if term.length == candidate.length {
                                distance = input.length - candidate.length
                            }
                            
                            else if input.length == candidate.length {
                                distance = term.length - candidate.length
                            }
                            
                            //common prefixes and suffixes are ignored, because this speeds up the Damerau-levenshtein-Distance calculation without changing it.
                            else {
                                var ii = 0, jj = 0

                                while ii < term.length && ii < input.length && (term[term.startIndex.advancedBy(ii)] == input[input.startIndex.advancedBy(ii)]) {
                                    ii++
                                }
                                
                                while (jj < term.length - ii) && (jj < input.length - ii)
                                    && (term[term.startIndex.advancedBy(term.length - jj - 1)] == input[input.startIndex.advancedBy(input.length - jj - 1)]) {
                                    jj++
                                }
                                
                                if ii > 0 || jj > 0 {
                                    distance = DamerauLevenshteinDistance(term[ii..<term.length - jj], target: input[ii..<input.length - jj])
                                } else {
                                    distance = DamerauLevenshteinDistance(term, target: input)
                                }
                            }
                        }
                        
                        //save some time.
                        //remove all existing suggestions of higher distance, if verbose<2
                        if verbose < 2 && suggestions.count > 0 && (suggestions[0].distance > distance) {
                            suggestions.removeAll()
                        }
                        
                        //do not process higher distances than those already found, if verbose<2
                        if verbose < 2 && suggestions.count > 0 && distance > suggestions[0].distance {
                            continue
                        }
                        
                        if distance <= editDistanceMax {
                            if let val = dictionary[language + term] {
                                var suggestionItem = SuggestItem()
                                suggestionItem.term = term
                                suggestionItem.count = val.count
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
                    var term = candidate.term
                    term.removeAtIndex(term.startIndex.advancedBy(i))
                    let delete = Term(string: term)
                    
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
        let m: Int = source.length
        let n: Int = target.length
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