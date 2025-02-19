//
//  Country_EncyclopediaApp.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import SwiftUI
import SwiftData

@main
struct Country_EncyclopediaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteCountry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var countrySearchVM = CountrySearchViewModel(networkService: NetworkService())

    var body: some Scene {
        WindowGroup {
            CountrySearchView()
                .environment(countrySearchVM)
        }
        .modelContainer(sharedModelContainer)
    }
}
