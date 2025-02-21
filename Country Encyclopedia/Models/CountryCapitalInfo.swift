//
//  CountryCapitalInfo.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

struct CountryCapitalInfo: Codable {
    var latitude: Double?
    var longitude: Double?
    
    init(latitude: Double? = nil, longitude: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(latlng: [Double]? = nil) {
        if let coords = latlng, coords.count == 2 {
            self.latitude = coords[0]
            self.longitude = coords[1]
        } else {
            self.latitude = nil
            self.longitude = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        
        if latitude == nil || longitude == nil {
            if let coords = try? container.decode([Double].self, forKey: .latitude), coords.count == 2 {
                latitude = coords[0]
                longitude = coords[1]
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
    }
}


