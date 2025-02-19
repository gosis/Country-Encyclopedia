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
    private var populationActor: PopulationActor?
    private let countryCodeActor = CountryCodeActor()
    private let languagesActor = LanguagesActor()
    private let networkService: any NetworkServiceProtocol
    
    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func configureCountriesIfNeeded() async {
        guard countriesDict.count == 0 else { return }
        
        // TODO fix
        let countries = try! await networkService.fetchData() as! [Country]
                
        for country in countries {
                        
            // Insert country name in the Trie
            // and in quicklookup dict
            let name = country.name.common.lowercased()
            await countriesSearchActor.insert(name)
            countriesDict[name] = country
            
            //add to country codes lookup
            await countryCodeActor.appendCountry(code: country.cca3, name: name)
            
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
            
            // add each language to languages actor cache
            if let languages = country.languages {
                for language in languages.list {
                    await languagesActor.append(language: language, name: name)
                }
            }
        }
        
        populationActor = PopulationActor(countries: countries)
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
            
            // Iterate each found countryName
            // find corresponding country in countriesDict and remove duplicates
            // by using Set
            let countryNamesSet = Set(
                foundCountryNames.compactMap { countriesDict[$0]?.name.common.lowercased() }
            )
            
            // Return filtered country names
            return countryNamesSet.compactMap { countriesDict[$0] }
        }.value
        
        
        self.foundCountries = countries
    }
    
    @MainActor
    func getPopulationRank(name: String) async -> Int? {
        return await populationActor?.populationDict[name]
    }
    
    @MainActor
    func getCountryByCode(code: String) async -> Country? {
        guard let name = await countryCodeActor.getCountryName(code: code) else { return nil }
        
        return countriesDict[name]
    }
    
    @MainActor
    func getCountryNamesForLanguage(language: String) async -> Array<Country> {
        guard let countries = await languagesActor.getCountryCodesForLanguage(language) else { return [] }
        
        var countriesArray: [Country] = []
        for countryName in countries {
            if let country = countriesDict[countryName] {
                countriesArray.append(country)
            }
        }
        
        return countriesArray
    }
}
