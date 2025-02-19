//
//  MockNetworkService.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 19/02/2025.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol {
    func fetchData() async throws -> [Country] {
        MockData.mockCountries()
    }
    
    typealias T = [Country]
    var url: URL?
}
