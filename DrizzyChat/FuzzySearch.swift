

/*
    Fuzzy search finds
*/
func fuzzySearch(var originalString: String, var stringToSearch: String, caseSensitive: Bool = false) -> Bool {

    if count(originalString) == 0 || count(stringToSearch) == 0 {
        return false
    }

    if count(originalString) < count(stringToSearch){
        return false
    }

    if caseSensitive {
        originalString = originalString.lowercaseString
        stringToSearch = stringToSearch.lowercaseString
    }
    
    var searchIndex : Int = 0

    for charOut in originalString {
        for (indexIn, charIn) in enumerate(stringToSearch) {
            if indexIn == searchIndex {
                if charOut == charIn {
                    searchIndex++
                    if searchIndex == count(stringToSearch) {
                        return true;
                    }
                    else {
                        break
                    }
                }
                else {
                    break
                }

            }
        }
    }
    return false
}
