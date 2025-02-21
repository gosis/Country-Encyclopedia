//
//  MockModelContext.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 20/02/2025.
//

import SwiftData

class MockModelContext {
    @MainActor static func inMemoryModelContext() -> ModelContext {
        let schema = Schema([Country.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return container.mainContext
        } catch {
            fatalError("Failed to create in-memory ModelContainer: \(error)")
        }
    }
    
    static func mockLocalCountriesModelActor() -> LocalCountriesModelActor {
        let schema = Schema([Country.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return LocalCountriesModelActor.init(modelContainer: container)
        } catch {
            fatalError("Failed to create in-memory ModelContainer: \(error)")
        }
    }
}
