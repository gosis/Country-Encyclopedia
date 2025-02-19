//
//  MockData.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 19/02/2025.
//

import Foundation

class MockData {
    public static func mockCountries() -> [Country] {
        if let countries: [Country] = loadJSONFromFile(fileName: "countries") {
            return countries
        }
        
        return []
    }
    
    private static func loadJSONFromFile<T: Decodable>(fileName: String) -> T? {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }

        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            return nil
        }
    }
}
