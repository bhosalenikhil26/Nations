//
//  CountriesViewModel.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

protocol CountriesViewModelProtocol: ObservableObject {
    var countriesWithFlag: [CountryWithFlag] { get }
    var loadingState: LoadingState { get }
    var showAlert: Bool { get set }

    func viewAppeared() async
    func didSelectCountry(at index: Int)
    func didTapRetry() async
}

final class CountriesViewModel {
    @Published var countriesWithFlag: [CountryWithFlag] = []
    @Published var loadingState: LoadingState = .initial
    @Published var showAlert = false

    private let countryLoaderService: CountryLoaderServiceProtocol
    private var countries: [Country] = []


    init(countryLoaderService: CountryLoaderServiceProtocol) {
        self.countryLoaderService = countryLoaderService
    }
}

extension CountriesViewModel: CountriesViewModelProtocol {
    func viewAppeared() async {
        await loadCountries()
    }

    func didSelectCountry(at index: Int) {}

    func didTapRetry() async {
      await loadCountries()
    }
}

private extension CountriesViewModel {
    @MainActor func updateCountries(_ countries: [Country]) async {
        countriesWithFlag = countries.map { CountryWithFlag(name: $0.name.common, flag: $0.flag) }
    }

    @MainActor func updateState(_ state: LoadingState) {
        loadingState = state
    }

    @MainActor func showAlert(_ shouldShow: Bool) {
        showAlert = shouldShow
    }

    func loadCountries() async {
        await updateState(.loading)
        do {
            countries = try await countryLoaderService.loadCountries(with: ["name", "flag", "region", "currency", "languages", "capital", "flags"])
            await updateCountries(countries)
            await updateState(.loaded)
        } catch {
            print("Error while loading countries", error) //Log remote error
            await showAlert(true)
            await updateState(.initial)
        }
    }
}

struct CountryWithFlag {
    let name: String
    let flag: String
}

enum LoadingState {
    case initial
    case loading
    case loaded
}
