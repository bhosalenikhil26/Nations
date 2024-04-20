//
//  APICountryLoaderService.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import Foundation

protocol APICountryLoaderProtocol: APIServiceProtocol {
    func loadCountries(with details: [String]) async throws -> APICountryLoaderService.FetchCountriesResponse
}

final class APICountryLoaderService {}

extension APICountryLoaderService: APICountryLoaderProtocol {
    func loadCountries(with details: [String]) async throws -> APICountryLoaderService.FetchCountriesResponse {
        let request = APICountryRequest.fetchCountries(request: APICountryLoaderService.FetchCountriesRequest(details: details))
        let data = try await executeApiRequest(request)
        do {
            return try JSONDecoder().decode(APICountryLoaderService.FetchCountriesResponse.self, from: data)
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
        let countries: [Country]

        struct Country: Decodable {
            let flags: Flag
            let name: NameConfig
        }

        struct Flag: Decodable {
            let png: String
            let svg: String
            let alt: String
        }

        struct NameConfig: Decodable {
            let common: String
            let official: String
        }
    }
}
