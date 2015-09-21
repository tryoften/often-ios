
func fuzzySearch(var originalString: String, var stringToSearch: String, caseSensitive: Bool = true) -> Bool {

    if originalString.characters.count == 0 || stringToSearch.characters.count == 0 {
        return false
    }

    if originalString.characters.count < stringToSearch.characters.count {
        return false
    }

    if caseSensitive {
        originalString = originalString.lowercaseString
        stringToSearch = stringToSearch.lowercaseString
    }

    var searchIndex: Int = 0

    for charOut in originalString.characters {
        for (indexIn, charIn) in stringToSearch.characters.enumerate() {
            if indexIn == searchIndex {
                if charOut == charIn{
                    searchIndex++
                    if searchIndex == stringToSearch.characters.count {
                        return true
                    } else {
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