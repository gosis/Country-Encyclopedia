//
//  CountryName.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

struct CountryName: Codable {
    let common: String
    let official: String
    let nativeName: [String: CountryTranslation]?
}
