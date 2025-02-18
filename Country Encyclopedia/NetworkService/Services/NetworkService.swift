//
//  NetworkService.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

actor NetworkService: @preconcurrency NetworkServiceProtocol {
    typealias T = [Country]
    
    var url: URL? { URL(string: "https://restcountries.com/v3.1/all") }
    
    func fetchData() async throws -> [Country] {
        guard let url = url else {
            throw NSError(domain: "NetworkService", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "NetworkService", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NSError(domain: "NetworkService", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"])
        }
    }
}
