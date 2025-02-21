//
//  SearchActor.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

actor SearchActor {
    
    private let trie = Trie()
    
    func insert(_ word: String) {
        trie.insert(word: word)
    }

    func searchPrefix(_ prefix: String) -> [String] {
        return trie.searchPrefix(prefix)
    }
}
