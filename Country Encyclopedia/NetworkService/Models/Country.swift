//
//  Country.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

struct Country: Codable, Hashable, Sendable {
    let name: CountryName
    let tld: [String]?
    let cca2: String
    let ccn3: String?
    let cca3: String
    let independent: Bool?
    let status: String
    let unMember: Bool
    let currencies: [String: CountryCurrency]?
    let idd: CountryIDD
    let capital: [String]?
    let altSpellings: [String]
    let region: String
    let subregion: String?
    let languages: CountryLanguages?
    let translations: [String: CountryTranslation]
    let latlng: [Double]
    let landlocked: Bool
    let area: Double
    let demonyms: [String: CountryDemonym]?
    let flag: String
    let maps: CountryMaps
    let population: Int
    let timezones: [String]
    let continents: [String]
    let flags: CountryFlag
    let coatOfArms: CountryCoatOfArms?
    let startOfWeek: String
    let capitalInfo: CountryCapitalInfo?
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(name.common)
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name.common == rhs.name.common
    }
}
