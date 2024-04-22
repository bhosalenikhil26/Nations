//
//  CountryLoaderService.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

protocol CountryLoaderServiceProtocol {
    func loadCountries(with details: [String]) async throws -> [Country]
    func getImage(with url: String) async -> Image?
}

final class CountryLoaderService {
    private let apiCountryLoaderService: APICountryLoaderServiceProtocol
    private var flagImageCache: [String: Image] = [:]

    init(apiCountryLoaderService: APICountryLoaderServiceProtocol) {
        self.apiCountryLoaderService = apiCountryLoaderService
    }
}

extension CountryLoaderService: CountryLoaderServiceProtocol {
    func loadCountries(with details: [String]) async throws -> [Country] {
        try await apiCountryLoaderService.loadCountries(with: details)
    }

    func getImage(with url: String) async -> Image? {
        if let flagImage = flagImageCache[url] {
            return flagImage
        }
        guard let imageData = try? await apiCountryLoaderService.downloadFile(for: url),
              let uiImage = UIImage(data: imageData) else { return nil }
        let flagImage = Image(uiImage: uiImage)
        if flagImageCache.count <= 50 { //To avoid memory overflow issue, we are limiting image cache to 50 images.
            flagImageCache[url] = flagImage
        }
        return flagImage
    }
}
