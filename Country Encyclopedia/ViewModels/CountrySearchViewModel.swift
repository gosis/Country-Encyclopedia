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
    
    // Cache of all countries accessible by their name in O(1) time
    private var countriesCache = KeyValueCacheActor<Country>()
    
    //Cache of country name and its corresponding population rank accesible in O(1) time
    private var populationRankCache: KeyValueCacheActor<Int>?
    
    // Cache of country name and its corresponding country code accesible in O(1) time
    private var countryCodeCache = KeyValueCacheActor<String>()
    
    //Cache of country name and its corresponding langauges accesible in O(1) time
    private var countryLanguageCache = KeyValueCacheActor<Set<String>>()
    
    // Search actor holding a trie of all country names
    private let searchActor = SearchActor()
    private let networkService: any NetworkServiceProtocol
    
    private let localCountriesModelActor: LocalCountriesModelActor
    
    init(networkService: any NetworkServiceProtocol,
         localCountriesModelActor: LocalCountriesModelActor) {
        self.networkService = networkService
        self.localCountriesModelActor = localCountriesModelActor
    }
    
    func configureCountriesIfNeeded() async {
        guard await countriesCache.count == 0 else { return }
        
        var countries = await localCountriesModelActor.loadLocalCountries()
        
        // If local DB is empty
        // load countries from network
        // and store in DB
        if countries.isEmpty {
            if let networkCountries = try? await networkService.fetchData() as? [Country] {
                countries = networkCountries
            }
            
            await localCountriesModelActor.addLocalCountries(countries)
        }
        
        var populationArray = [(name:String, population: Int)]()
                        
        for country in countries {
            
            // store population in temp array
            populationArray.append((name: country.name.common, population: country.population))
                        
            // Insert country name in the Trie
            // and in quicklookup dict
            let name = country.name.common.lowercased()
            await searchActor.insert(name)
            await countriesCache.setValue(country, for: name)
            
            //add to country codes cache
            await countryCodeCache.setValue(name, for: country.cca3)
            
            // Insert all translated country names
            // that don't match the name already inserted
            // in trie and in quick lookup dict
            if let translations = country.translations {
                for (_, value) in translations {
                    let commonName = value.common.lowercased()
                    if commonName != name {
                        await searchActor.insert(commonName)
                        await countriesCache.setValue(country, for: commonName)
                    }
                }
            }
            
            // add each language to language cache for its corresponding country name
            if !country.languages.isEmpty {
                for language in country.languages {
                    await countryLanguageCache.appendToSet(name, for: language)
                }
            }
        }
        
        // format population rank cache
        populationArray.sort { $0.population > $1.population }
        var tempPopulationDict = [String: Int]()
        for (index, data) in populationArray.enumerated() {
            tempPopulationDict[data.name] = index + 1
        }
        
        populationRankCache = KeyValueCacheActor(storage: tempPopulationDict)
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
            let foundCountryNames = await searchActor.searchPrefix(trimmedPrefix)
            
            // Iterate each found countryName
            // find corresponding country in countriesDict and remove duplicates
            // by using Set
            let cache = self.countriesCache
            let countryNamesSet = Set<String>(
                await withTaskGroup(of: String?.self) { group in
                    for name in foundCountryNames {
                        group.addTask {
                            return await cache.getValue(for: name)?.name.common.lowercased()
                        }
                    }
                    
                    var results = [String]()
                    for await result in group {
                        if let name = result {
                            results.append(name)
                        }
                    }
                    
                    return results
                }
            )

            // Return filtered country names
            return await withTaskGroup(of: Country?.self) { group in
                for name in countryNamesSet {
                    group.addTask {
                        return await cache.getValue(for: name)
                    }
                }
                
                var results = [Country]()
                for await result in group {
                    if let country = result {
                        results.append(country)
                    }
                }
                
                return results
            }

        }.value
        
        
        self.foundCountries = countries
    }
    
    @MainActor
    func getPopulationRank(name: String) async -> Int? {
        return await populationRankCache?.getValue(for: name)
    }
    
    @MainActor
    func getCountryByCode(code: String) async -> Country? {
        guard let name = await countryCodeCache.getValue(for: code) else { return nil }
        
        return await countriesCache.getValue(for: name)
    }
    
    @MainActor
    func getCountryNamesForLanguage(language: String) async -> Array<Country> {
        guard let countries = await countryLanguageCache.getValue(for: language) else { return [] }
        
        var countriesArray: [Country] = []
        for countryName in countries {
            if let country = await countriesCache.getValue(for: countryName) {
                countriesArray.append(country)
            }
        }
        
        return countriesArray
    }
}

// Local model property change extension
// after each prop changes saveModel must be called
extension CountrySearchViewModel {
    func toggleFavorite(country: Country) async {
        country.toggleFavorite()
        await localCountriesModelActor.saveModel()
    }
}
