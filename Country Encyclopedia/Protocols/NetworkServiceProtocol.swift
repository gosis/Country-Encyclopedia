//
//  NetworkServiceProtocol.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    associatedtype T: Decodable
    var url: URL? { get }
    func fetchData() async throws -> T
}
