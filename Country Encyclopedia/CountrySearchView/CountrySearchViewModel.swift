//
//  CountrySearchViewModel.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

@Observable
class CountrySearchViewModel {
    
    public var foundCountries = [Country]()
    
    private var countriesDict = [String: Country]()
    private let countriesSearchActor = CountrySearchActor()
    private let networkService: any NetworkServiceProtocol
    
    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadCountries() async {
        
        // TODO fix
        let countries = try! await networkService.fetchData() as! [Country]
                
        for country in countries {
            
            // Insert country name in the Trie
            // and in quicklookup dict
            let name = country.name.common.lowercased()
            await countriesSearchActor.insert(name)
            countriesDict[name] = country
            
            // Insert all translated country names
            // that don't match the name already inserted
            // in trie and in quick lookup dict
            for (_, value) in country.translations {
                let commonName = value.common.lowercased()
                if commonName != name {
                    await countriesSearchActor.insert(commonName)
                    countriesDict[commonName] = country
                }
            }
        }
    }
    
    @MainActor
    func searchCountries(_ prefix: String) async {
        let countries = await Task<[Country], Never> {
            let trimmedPrefix = prefix.trimmingCharacters(in: .whitespaces).lowercased()
            
            if trimmedPrefix.count == 0 {
                return []
            }
            
            // foundCountryNames includes common and translated names
            // meaning it contains multiple names pointing to the same country
            let foundCountryNames = await countriesSearchActor.searchPrefix(trimmedPrefix)
            var countryNamesSet = Set<String>()
            
            // Iterate each found countryName
            // find corresponding country in countriesDict and remove duplicates
            // by using Set
            for name in foundCountryNames {
                if let country = countriesDict[name] {
                    let trimmedName = country.name.common.lowercased()
                    countryNamesSet.insert(trimmedName)
                }
            }
            
            // Return filtered country names
            return countryNamesSet.compactMap { countriesDict[$0] }
        }.value
        
        
        self.foundCountries = countries
    }
}
