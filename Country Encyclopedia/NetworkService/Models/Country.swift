//
//  Country.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

final class Country: Codable, Hashable, Sendable, Identifiable {
    var id: String { cca2 }
    
    let name: CountryName
    let cca2: String
    let cca3: String
    let capital: [String]?
    let languages: CountryLanguages?
    let translations: [String: CountryTranslation]
    let latlng: [Double]
    let borders: [String]?
    let population: Int
    let capitalInfo: CountryCapitalInfo?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name.common)
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name.common == rhs.name.common
    }
}

extension Country {
    
    func getCapitalCoordinates() -> (latitude: Double, longitude: Double)? {
        
        // try extracting capital coordinates first
        if let capitalCoords = self.capitalInfo?.latlng, capitalCoords.count == 2 {
            return (latitude: capitalCoords[0], longitude: capitalCoords[1])
        }
        
        // if not found use country coordinates
        let countryCoords = self.latlng
        if countryCoords.count == 2 {
            return (latitude: countryCoords[0], longitude: countryCoords[1])
        }
        
        return nil
    }
}
