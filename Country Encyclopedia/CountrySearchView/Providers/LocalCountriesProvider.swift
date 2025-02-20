//
//  LocalCountriesProvider.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 20/02/2025.
//

import Foundation
import SwiftData

@ModelActor
actor LocalCountriesProvider {
    
    func loadLocalCountries() async -> [Country] {
        let descriptor = FetchDescriptor<Country>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load countries: \(error)")
            return []
        }
    }
    
    func addLocalCountries(_ countries: [Country]) async {
        for country in countries {
            modelContext.insert(country)
        }
        do {
            try modelContext.save()
            print("Successfully saved countries.")
        } catch {
            print("Failed to save countries: \(error)")
        }
    }
    
    func saveModel() {
        do {
            try modelContext.save()
            print("Successfully saved countries.")
        } catch {
            print("Failed to save countries: \(error)")
        }
    }
}
