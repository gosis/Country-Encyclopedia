//
//  Trie.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

fileprivate class TrieNode<T: Hashable> {
    
    var value: T?
    var isTerminating = false
    weak var parent: TrieNode?
    var children: [T: TrieNode] = [:]
  
    public init(value: T? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
    }
    
    func add(child: T) {
        guard children[child] == nil else {
            return
        }

        children[child] = TrieNode(value: child, parent: self)
    }
}

public class Trie {
    
    fileprivate typealias Node = TrieNode<Character>
    
    fileprivate let root: Node

    public init() {
        root = Node()
    }
    
    public func searchPrefix(_ prefix: String) -> [String] {
        var node = root
        for char in prefix.lowercased() {
            guard let nextNode = node.children[char] else {
                return []
            }
            node = nextNode
        }
        return collectWords(node, prefix.lowercased())
    }
    
    private func collectWords(_ node: TrieNode<Character>, _ prefix: String) -> [String] {
        var results: [String] = []
        if node.isTerminating {
            results.append(prefix)
        }

        for (char, nextNode) in node.children {
            results += collectWords(nextNode, prefix + String(char))
        }
        return results
    }
}

extension Trie {
    
    public func insert(word: String) {
    
        guard !word.isEmpty else {
            
            return
        }

        var currentNode = root
       
        let characters = Array(word.lowercased())
        var currentIndex = 0

        while currentIndex < characters.count {
            
            let character = characters[currentIndex]

            if let child = currentNode.children[character] {
            
                currentNode = child
            } else {
            
                currentNode.add(child: character)
                currentNode = currentNode.children[character]!
            }
          
            currentIndex += 1

            if currentIndex == characters.count {
                
              currentNode.isTerminating = true
            }
        }
    }
    
    public func contains(word: String) -> Bool {
        
        guard !word.isEmpty else {
        
            return false
        }
        var currentNode = root

        let characters = Array(word.lowercased())
        var currentIndex = 0

        while currentIndex < characters.count,
              let child = currentNode.children[characters[currentIndex]] {

          currentIndex += 1
          currentNode = child
        }
        
        if currentIndex == characters.count
            && currentNode.isTerminating {
            
            return true
        } else {
            
            return false
        }
    }
}
