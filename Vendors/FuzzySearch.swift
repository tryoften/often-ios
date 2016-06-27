
func fuzzySearch(_ originalString: String, stringToSearch: String, caseSensitive: Bool = true) -> Bool {
    var originalString = originalString, stringToSearch = stringToSearch

    if originalString.characters.count == 0 || stringToSearch.characters.count == 0 {
        return false
    }

    if originalString.characters.count < stringToSearch.characters.count {
        return false
    }

    if caseSensitive {
        originalString = originalString.lowercased()
        stringToSearch = stringToSearch.lowercased()
    }

    var searchIndex: Int = 0

    for charOut in originalString.characters {
        for (indexIn, charIn) in stringToSearch.characters.enumerated() {
            if indexIn == searchIndex {
                if charOut == charIn{
                    searchIndex += 1
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
