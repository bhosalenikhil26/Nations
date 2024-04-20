//
//  APICountryLoaderService.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import Foundation

typealias Country = APICountryLoaderService.FetchCountriesResponse.Country

protocol APICountryLoaderServiceProtocol: APIServiceProtocol {
    func loadCountries(with details: [String]) async throws -> [Country]
}

final class APICountryLoaderService {}

extension APICountryLoaderService: APICountryLoaderServiceProtocol {
    func loadCountries(with details: [String]) async throws -> [Country] {
        let request = APICountryRequest.fetchCountries(request: APICountryLoaderService.FetchCountriesRequest(details: details))
        let data = try await executeApiRequest(request)
        do {
            return try JSONDecoder().decode([Country].self, from: data)
        } catch {
            throw APIError.couldNotParseToSpecifiedModel
        }
    }
}

extension APICountryLoaderService {
    struct FetchCountriesRequest {
        let details: [String]
    }

    struct FetchCountriesResponse: Decodable {
        struct Country: Decodable {
            let flags: Flag
            let name: NameConfig
            let capital: [String]
            let region: String
            let flag: String
        }

        struct Flag: Decodable {
            let svg: String
            let alt: String
        }

        struct NameConfig: Decodable {
            let common: String
            let official: String
        }
    }
}
