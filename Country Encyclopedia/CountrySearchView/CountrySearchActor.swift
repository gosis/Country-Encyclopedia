//
//  CountrySearchActor.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

actor CountrySearchActor {
    
    private let countriesTrie = Trie()
    
    func insert(_ word: String) {
        countriesTrie.insert(word: word)
    }

    func searchPrefix(_ prefix: String) -> [String] {
        return countriesTrie.searchPrefix(prefix)
    }
}
