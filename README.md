# Offline-First Country Searcher

Country searcher test using [restcountries.com](https://restcountries.com/v3.1/all) as the data source. 
- Implements an offline first country search and detail view
- Provides A `ViewModel` that **fetches** and **stores country data locally** using `SwiftData`.
- Data is indexed using Key value stores and `Trie` for faster search and O(1) lookup for most cases

---

## Getting Started

* To use `CountrSearchViewModel` your app must use `SwiftData` and must provide access to `modelContext`
* Copy `CountrSearchViewModel` contents  to your project or extract into a Swift Package
* Initialise `CountrySearchViewModel` as the `ViewModel` for your view that needs to load/use country data
* Use public functions on `CountrySearchViewModel` from within background context using Swift `async/await`

---

## Usage

### `@Observable CountrySearchViewModel`
The main `ViewModel` responsible for loading, indexing countries, and managing search functionality.

---

```swift
init(networkService: any NetworkServiceProtocol,
     localCountriesModelActor: LocalCountriesModelActor)
```
* Requires `@ModelActor` `LocalCountriesModelActor` initialised with your apps base Swift Data context `ModelContext`
* To use resctountries.com use provided `NetworkService()` as dependency

---

```swift
func configureCountriesIfNeeded() async
```
* Load and index list of `Country` instances from API or local storage
* If indexing is done already this is no-op
* Must be called before any other functions in the view model

---

```swift
@MainActor func searchCountries(_ prefix: String) async
```
* Search countries for given prefix string
* Prefix has no length limits, search will start at one letter
* Must be called in async manner.
* Result will populate `foundCountries` with a list of countries for given prefix

---

```swift
@MainActor func getPopulationRank(_ name: String) async -> Int?
```
* Return population rank for given country
* MainActor that can be called from background thread
* Will return population rank `Int` in O(1) time in most cases

---

```swift
@MainActor func getCountryByCode(_ code: String) async -> Country?
```
* Helper function to quickly return `Country` for given country code (cca3)
* MainActor that can be called from background thread
* Will lookup in O(1) time in most cases

---

```swift
@MainActor func getCountryNamesForLanguage(_ language: String) async -> Array<Country>
```
* Returns an unordered `Set` of `Country` instances that speak the given language
* `MainActor` that can be called from background thread
* Will lookup in O(1) time in most cases

---

```swift
func toggleFavorite(country: Country) async
```
* Toggle the favorite flag on given country
* Will call `saveModel` on your given `ModelContext` container provided in `init`

---
## Examples
* Project includes 2 Views demonstating the use of `CountrySearchViewModel`
* `CountrySearchView` demonstrates a simple country searching UI
* `CountryDetailView` demonstrates a detail view that displays extra detail about given country
  like other countries using the same language or population rank

## View model functionality
* `CountrySearchViewModel` keeps a `Trie` of all found country names
* `Trie` holds country common name, and translated names like "Läti" or "Letónia"
* `CountrySearchViewModel` holds quick lookup key value actors for quick access for following properties
  * Population rank for a country
  * country code (cca3) for given country
  * A Set of country names using the same language
* Country instance is serialised in SwiftData

## Swift Data storage
* All loaded `Country` instances are stored in `SwiftData` for offline access
* On top of API properties a `isFavorite` flag is added on all `Country` instances
* To ensure `SwiftData` compliance some variables on `Country` are serialised into JSON and decoded on the fly

## Testing
* Example Views provided use data from `Mocks` folder to implement #preview for Views implementing `CountrySearchViewModel`
* `MockNetworkService` provides `NetworkServiceProtocol` implementation with static data
* `MockModelContext` provides initialisers to mock in memory `ModelContext` and a `LocalCountriesModelActor` with in memory SwiftData storage
* `MockData` loads full restcountries.com API response from `countries.json` file
* @see `#preview` implementation of Example views to see how mock data are set up





