//
//  LanguagesActor.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 19/02/2025.
//

import Foundation

actor LanguagesActor {
    
    private var languagesDict = [String: Set<String>]()
    
    func append(language: String, name: String) {
        if let _ = languagesDict[language] {
            languagesDict[language]?.insert(name)
        } else {
            languagesDict[language] = [name]
        }
    }
    
    func getCountryCodesForLanguage(_ language: String) -> Set<String>? {
        return languagesDict[language]
    }
}
