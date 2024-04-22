//
//  CountryDetailsViewModel.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-21.
//

import SwiftUI

protocol CountryDetailsViewModelProtocol: ObservableObject {
    var image: Image? { get }
    var countryOfficialName: String { get }
    var region: String { get }
    var capital: String { get }
    var countryCode: String { get }
    var countryCommonName: String { get }

    func viewAppeared() async
}

final class CountryDetailsViewModel {
    private let country: Country
    private let countryLoaderService: CountryLoaderServiceProtocol

    @Published var image: Image?

    init(country: Country, countryLoaderService: CountryLoaderServiceProtocol) {
        self.country = country
        self.countryLoaderService = countryLoaderService
    }
}

extension CountryDetailsViewModel: CountryDetailsViewModelProtocol {
    func viewAppeared() async {
       await fetchImage()
    }

    var countryOfficialName: String {
        country.name.official
    }

    var region: String {
        country.region
    }

    var capital: String {
        country.capital.map { $0 }.joined(separator: ",")
    }

    var countryCode: String {
        guard country.idd.suffixes.count == 1 else {
            return country.idd.root
        }
        return country.idd.root + country.idd.suffixes[0]
    }

    var countryCommonName: String {
        country.name.common
    }
}

private extension CountryDetailsViewModel {
    @MainActor func fetchImage() async {
        image = await countryLoaderService.getImage(with: country.flags.png) ?? Image(.imagePlaceholder)
    }
}
