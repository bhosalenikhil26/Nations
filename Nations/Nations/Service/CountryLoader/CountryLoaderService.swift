//
//  CountryLoaderService.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import Foundation

protocol CountryLoaderServiceProtocol {
    func loadCountries(with details: [String]) async throws -> [Country]
}

final class CountryLoaderService {
    private let apiCountryLoaderService: APICountryLoaderServiceProtocol

    init(apiCountryLoaderService: APICountryLoaderServiceProtocol) {
        self.apiCountryLoaderService = apiCountryLoaderService
    }
}

extension CountryLoaderService: CountryLoaderServiceProtocol {
    func loadCountries(with details: [String]) async throws -> [Country] {
        try await apiCountryLoaderService.loadCountries(with: details)
    }
}
