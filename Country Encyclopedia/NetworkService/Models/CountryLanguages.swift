//
//  CountryLanguages.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

class CountryLanguages: Codable, @unchecked Sendable {
    let list: [String]

    init(list: [String]) {
        self.list = list
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let languagesDict = try? container.decode([String: String].self) {
            list = languagesDict.map { $0.value }
        } else {
            print("Failed to decode languages")
            list = []
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let languagesDict = Dictionary(uniqueKeysWithValues: list.enumerated().map { ("lang\($0.offset)", $0.element) })
        try container.encode(languagesDict)
    }
}
