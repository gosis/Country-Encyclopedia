//
//  CountryCodeActor.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 19/02/2025.
//

import Foundation

actor CountryCodeActor {
    private var countryCodeDict = [String: String]()
    
    func appendCountry(code: String, name: String) async {
        countryCodeDict[code] = name
    }
    
    func getCountryName(code: String) async -> String? {
        countryCodeDict[code]
    }
}
