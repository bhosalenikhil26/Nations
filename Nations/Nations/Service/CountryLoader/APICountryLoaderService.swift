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
    func downloadFile(for url: String) async throws -> Data
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

    func downloadFile(for url: String) async throws -> Data {
        let request = APICountryRequest.downloadFile(url: url)
        return try await executeApiRequest(request)
    }
}

extension APICountryLoaderService {
    struct FetchCountriesRequest {
        let details: [String]
    }

    struct FetchCountriesResponse: Decodable {
        struct Country: Decodable, Hashable {
            let flags: Flag
            let name: NameConfig
            let capital: [String]
            let region: String
            let flag: String
            let idd: CountryCode
        }

        struct Flag: Decodable, Hashable {
            let png: String
        }

        struct NameConfig: Decodable, Hashable {
            let official: String
            let common: String
        }

        struct CountryCode: Decodable, Hashable {
            let root: String
            let suffixes: [String]
        }
    }
}
