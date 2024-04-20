//
//  CountryLoaderService.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import Foundation

protocol CountryLoaderServiceProtocol {
    func loadCountries(with details: [String]) async throws -> APICountryLoaderService.FetchCountriesResponse
}

final class CountryLoaderService {
    private let apiCountryLoaderService: APICountryLoaderProtocol

    init(apiCountryLoaderService: APICountryLoaderProtocol) {
        self.apiCountryLoaderService = apiCountryLoaderService
    }
}

extension CountryLoaderService: CountryLoaderServiceProtocol {
    func loadCountries(with details: [String]) async throws -> APICountryLoaderService.FetchCountriesResponse {
        try await apiCountryLoaderService.loadCountries(with: details)
    }
}
