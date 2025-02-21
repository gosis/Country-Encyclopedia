//
//  Country.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import SwiftData

@Model
final class Country: Hashable, @unchecked Sendable {
    
    init(name: CountryName,
         cca2: String,
         cca3: String,
         population: Int,
         capitalInfo: CountryCapitalInfo? = nil,
         isFavorite: Bool,
         bordersJson: String?,
         latlngJson: String?,
         translationsJson: String?,
         capitalJson: String?,
         languagesJson: String?
    ) {
        self.name = name
        self.cca2 = cca2
        self.cca3 = cca3
        
        self.translationsJSON = translationsJson
        self.capitalJSON = capitalJson
        self.latlngJSON = latlngJson
        self.bordersJSON = bordersJson
        self.languagesJSON = languagesJson
        
        self.population = population
        self.capitalInfo = capitalInfo
        self.isFavorite = isFavorite
    }
        
    // Directly Stored in SwiftData
    private(set) var name: CountryName
    private(set) var cca2: String
    private(set) var cca3: String
    private(set) var population: Int
    private(set) var isFavorite: Bool
    private(set) var capitalInfo: CountryCapitalInfo?
    
    // JSON strings of incompatible SwiftData types [String] [Double]
    // stored in SwiftData as JSON encoded strings
    private var capitalJSON: String?
    private var translationsJSON: String?
    private var latlngJSON: String?
    private var bordersJSON: String?
    private var languagesJSON: String?
    
    // Publicly Exposed properties loaded from json strings
    @Transient var capital: [String]? {
        get {
            JSONUtilities.decodeArray(capitalJSON) as [String]?
        }
    }
    @Transient var translations: [String: CountryTranslation]? {
        get {
            JSONUtilities.decodeDict(translationsJSON) as [String: CountryTranslation]?
        }
    }
    @Transient var latlng: [Double]? {
        get {
            JSONUtilities.decodeArray(latlngJSON) as [Double]?
        }
    }
    @Transient var borders: [String]? {
        get {
            JSONUtilities.decodeArray(bordersJSON) as [String]?
        }
    }
    @Transient var languages: [String] {
        get {
            if let languagesDict = JSONUtilities.decodeDict(languagesJSON) as [String: String]? {
                return Array(languagesDict.values)
            }
            return []
        }
    }

    
    func toggleFavorite() {
        isFavorite = !isFavorite
    }
}

extension Country: Identifiable {
    
    var id: String { cca2 }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cca2)
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.cca2 == rhs.cca2
    }
}

extension Country: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(cca2, forKey: .cca2)
        try container.encode(cca3, forKey: .cca3)
        try container.encode(population, forKey: .population)
        try container.encode(isFavorite, forKey: .isFavorite)
        
        try container.encode(capitalJSON, forKey: .capitalJSON)
        try container.encode(translationsJSON, forKey: .translationsJSON)
        try container.encode(latlngJSON, forKey: .latlngJSON)
        try container.encode(bordersJSON, forKey: .bordersJSON)
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(CountryName.self, forKey: .name)
        let cca2 = try container.decode(String.self, forKey: .cca2)
        let cca3 = try container.decode(String.self, forKey: .cca3)
        let population = try container.decode(Int.self, forKey: .population)
        let isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        
        var capitalJSON: String?
        if let networkCapital = try container.decodeIfPresent([String].self, forKey: .capital) {
            capitalJSON = JSONUtilities.encodeArray(networkCapital)
        } else {
            capitalJSON = try container.decodeIfPresent(String.self, forKey: .capitalJSON)
        }
        
        var translationsJson: String?
        if let networkTranslations = try container.decodeIfPresent([String: CountryTranslation].self, forKey: .translationsJSON) {
            translationsJson = JSONUtilities.encodeDict(networkTranslations)
        } else {
            translationsJson = try container.decodeIfPresent(String.self, forKey: .translationsJSON)
        }
        
        var latlngJson: String?
        if let networkLatLng = try container.decodeIfPresent([Double].self, forKey: .latlng) {
            latlngJson = JSONUtilities.encodeArray(networkLatLng)
        } else {
            latlngJson = try container.decodeIfPresent(String.self, forKey: .latlngJSON)
        }
        
        var languagesJson: String?
        if let networkLanguages = try container.decodeIfPresent([String: String].self, forKey: .languages) {
            languagesJson = JSONUtilities.encodeDict(networkLanguages)
        } else {
            languagesJson = try container.decodeIfPresent(String.self, forKey: .languages)
        }
        
        var bordersJson: String?
        if let networkBorders = try container.decodeIfPresent([String].self, forKey: .borders) {
            bordersJson = JSONUtilities.encodeArray(networkBorders)
        } else {
            bordersJson = try container.decodeIfPresent(String.self, forKey: .bordersJSON)
        }
        
        self.init(name: name,
                  cca2: cca2,
                  cca3: cca3,
                  population: population,
                  isFavorite: isFavorite,
                  bordersJson: bordersJson,
                  latlngJson: latlngJson,
                  translationsJson: translationsJson,
                  capitalJson: capitalJSON,
                  languagesJson: languagesJson
        )
   }
    
    enum CodingKeys: String, CodingKey {
        case name, cca2, cca3, population, isFavorite
        case capitalJSON, capital, translationsJSON, translations,
             latlngJSON, latlng, bordersJSON, borders, languagesJSON, languages
    }
}

extension Country {
    
    func getCapitalCoordinates() -> (latitude: Double, longitude: Double)? {
        
        // try extracting capital coordinates first
        if let capitalInfo = self.capitalInfo,
            let latitude = capitalInfo.latitude,
            let longitude = capitalInfo.longitude {
            return (latitude: latitude, longitude: longitude)
        }
        
        // if not found use country coordinates
        if let latlng = self.latlng, latlng.count == 2 {
            return (latitude: latlng[0], longitude: latlng[1])
        }
        
        return nil
    }
}
