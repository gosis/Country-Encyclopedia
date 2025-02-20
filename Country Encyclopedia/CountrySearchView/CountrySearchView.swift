//
//  ContentView.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import SwiftUI
import SwiftData

struct CountrySearchView: View {
    
    @Environment(CountrySearchViewModel.self) var countrySearchVM
    
    @State private var selectedCountry: Country?
    @State private var path: [String] = []
    @State var searchText = ""
    
    var body: some View {
        NavigationStack() {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(countrySearchVM.foundCountries, id: \.self) { country in
                            Button(action: {
                                DispatchQueue.main.async {
                                    selectedCountry = country
                                }
                            }) {
                                HStack {
                                    Text(country.name.common)
                                        .foregroundColor(Color.black)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(Utilities.flagEmoji(from: country.cca2))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search for a country")
                .onChange(of: searchText) {
                    Task {
                        await countrySearchVM.searchCountries(searchText)
                    }
                }
                .background(AnimatingGradientView()
                    .ignoresSafeArea()
                )
                .sheet(item: $selectedCountry) { country in
                    CountryDetailView(country: country)
                }
            }
            .navigationTitle("Countries")
        }
        .tint(Color.primary)
        .onAppear {
            let countrySearchViewModel = countrySearchVM
            Task {
                await countrySearchViewModel.configureCountriesIfNeeded()
            }
        }
    }
}

#Preview {
    let mockNetworkService = NetworkService()
    let inMemoryModelContext = MockModelContext.inMemoryModelContext()
    let localCountriesProvider = MockModelContext.mockLocalCountriesProvider()
    let countrySearchVM = CountrySearchViewModel(networkService: mockNetworkService,
                                                 localCountriesProvider: localCountriesProvider)

    CountrySearchView()
        .environment(countrySearchVM)
}
