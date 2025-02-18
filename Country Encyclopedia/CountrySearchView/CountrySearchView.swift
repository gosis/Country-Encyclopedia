//
//  ContentView.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import SwiftUI
import SwiftData

struct CountrySearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var countrySearchVM = CountrySearchViewModel(networkService: NetworkService())
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(countrySearchVM.foundCountries, id: \.self) { country in
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
                .searchable(text: $searchText, prompt: "Search for a country")
                .onChange(of: searchText) {
                    Task {
                        await countrySearchVM.searchCountries(searchText)
                    }
                }
                .background(AnimatingGradientView()
                    .ignoresSafeArea()
                )
            }
            .navigationTitle("Countries")

        }
        .tint(Color.black)
        .onAppear {
            let countrySearchViewModel = countrySearchVM
            Task {
                await countrySearchViewModel.loadCountries()
            }
        }
    }
}

#Preview {
    CountrySearchView()
}
