import SwiftUI
import SwiftData

struct CountryDetailView: View {
    @Environment(CountrySearchViewModel.self) var countrySearchVM
    @State public var country: Country?
    
    @State private var populationRank: Int?
    @State private var selectedLanguage: String?
    @State private var selectedLanguageCountries: [Country]?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let country = self.country {
                    let commonName = country.name.common
                    let officialName = country.name.official
                    let code = country.cca3
                    let population = country.population
                    let capital = country.capital?.first
                    let coordinates = country.getCapitalCoordinates()
                    let borders = country.borders ?? []
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(officialName)
                                .font(.subheadline)
                                .bold()
                                .padding(.bottom, 2)
                            
                            HStack {
                                Text("Code: **\(code)**")
                                Spacer()
                                Text("Population: **\(population)**")
                            }
                            .font(.body)
                            .padding(.vertical, 5)
                            
                            if let rank = self.populationRank {
                                Text("**Population Rank:** #\(rank)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            
                            if !borders.isEmpty {
                                Text("Borders").font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(borders, id: \.self) { border in
                                            Button(action: {
                                                updateToBorderingCountry(code: border)
                                            }) {
                                                Text(border)
                                                    .font(.headline)
                                                    .padding()
                                                    .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.blue))
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 3)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 50)
                            }
                            
                            if let languages = country.languages, !languages.list.isEmpty {
                                Text("Spoken Languages").font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(languages.list, id: \.self) { language in
                                            Button(action: {
                                                selectedLanguage = language
                                                getCountriesForLanguage(language)
                                            }) {
                                                Text(language)
                                                    .font(.headline)
                                                    .padding()
                                                    .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.green))
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 3)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 50)
                            }
                            
                            if let coordinates {
                                MapView(latitude: coordinates.latitude,
                                        longitude: coordinates.longitude,
                                        placeName: capital ?? "")
                                    .frame(height: 250)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                    .navigationTitle(commonName)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            FlagView(countryCode: country.cca2)
                        }
                    }
                } else {
                    VStack {
                        Text("No country selected")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            let searchVM = countrySearchVM
            Task {
                await searchVM.configureCountriesIfNeeded()
                await refreshPopulationRank(country: country)
            }
        }
        .confirmationDialog("Other countries speaking \(selectedLanguage ?? "")",
                            isPresented: Binding(
                                get: { selectedLanguageCountries != nil },
                                set: { _ in selectedLanguageCountries = nil }
                            ),
                            titleVisibility: .visible) {
            if let selectedLanguageCountries {
                ForEach(selectedLanguageCountries, id: \.self) { country in
                    Button(country.name.common) {
                        self.country = country
                    }
                }
            }
            Button("Cancel", role: .cancel) { selectedLanguage = nil }
        }
    }
    
    private func getCountriesForLanguage(_ language: String) {
        Task {
            let countries = await self.countrySearchVM.getCountryNamesForLanguage(language: language)
            self.selectedLanguageCountries = countries
        }
    }
    
    private func updateToBorderingCountry(code: String) {
        Task {
            let country = await self.countrySearchVM.getCountryByCode(code: code)

            DispatchQueue.main.async {
                withAnimation {
                    self.country = country
                }
            }

            await refreshPopulationRank(country: country)
        }
    }
    
    private func refreshPopulationRank(country: Country?) async {
        guard let country = country else {
            self.populationRank = nil
            return
        }
        
        let populationRank = await countrySearchVM.getPopulationRank(name: country.name.common)
        withAnimation {
            self.populationRank = populationRank
        }
    }
}

#Preview {
    @Previewable @State var path: [String] = []
    let mockNetworkService = NetworkService()
    let countrySearchVM = CountrySearchViewModel(networkService: mockNetworkService)
    let mockCountries = MockData.mockCountries()
    
    CountryDetailView(country: mockCountries[0])
        .environment(countrySearchVM)
}
