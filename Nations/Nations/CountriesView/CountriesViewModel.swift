//
//  CountriesViewModel.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

protocol CountriesViewModelProtocol: ObservableObject {
    var countriesWithFlag: [CountryWithFlag] { get }

    func viewAppeared() async
    func didSelectCountry(at index: Int)
}

final class CountriesViewModel {
    @Published var countriesWithFlag: [CountryWithFlag] = []

    private let countryLoaderService: CountryLoaderServiceProtocol
    private var countries: [Country] = []

    init(countryLoaderService: CountryLoaderServiceProtocol) {
        self.countryLoaderService = countryLoaderService
    }
}

extension CountriesViewModel: CountriesViewModelProtocol {
    func viewAppeared() async {
        do {
            countries = try await countryLoaderService.loadCountries(with: ["name", "flag", "region", "currency", "languages", "capital", "flags"])
            await updateCountries(countries)
        } catch {
            print("Error while loading countries", error)
        }
    }

    func didSelectCountry(at index: Int) {}
}

private extension CountriesViewModel {
    @MainActor func updateCountries(_ countries: [Country]) {
        countriesWithFlag = countries.map { CountryWithFlag(name: $0.name.common, flag: $0.flag) }
    }
}

struct CountryWithFlag {
    let name: String
    let flag: String
}
