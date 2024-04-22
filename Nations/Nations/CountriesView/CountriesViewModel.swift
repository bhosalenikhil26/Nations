//
//  CountriesViewModel.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

protocol CountriesViewModelProtocol: ObservableObject {
    var countries: [Country] { get }
    var loadingState: LoadingState { get }
    var showAlert: Bool { get set }
    var shouldShowCountryDetails: Bool { get set }
    var countryDetailsViewModel: CountryDetailsViewModel? { get }

    func viewAppeared() async
    func didSelectCountry(_ country: Country) async
    func didTapRetry() async
}

final class CountriesViewModel {
    @Published var countries: [Country] = []
    @Published var loadingState: LoadingState = .initial
    @Published var showAlert = false
    @Published var shouldShowCountryDetails = false

    var countryDetailsViewModel: CountryDetailsViewModel?

    private let countryLoaderService: CountryLoaderServiceProtocol

    init(countryLoaderService: CountryLoaderServiceProtocol) {
        self.countryLoaderService = countryLoaderService
    }
}

extension CountriesViewModel: CountriesViewModelProtocol {
    func viewAppeared() async {
        await loadCountries()
    }

    func didSelectCountry(_ country: Country) async {
        countryDetailsViewModel = CountryDetailsViewModel(country: country, countryLoaderService: countryLoaderService)
        await shouldShowCountryDetails(true)
    }

    func didTapRetry() async {
      await loadCountries()
    }
}

private extension CountriesViewModel {
    @MainActor func updateCountries(_ countries: [Country]) async {
        self.countries = countries
    }

    @MainActor func updateState(_ state: LoadingState) {
        loadingState = state
    }

    @MainActor func showAlert(_ shouldShow: Bool) {
        showAlert = shouldShow
    }

    @MainActor func shouldShowCountryDetails(_ shouldShow: Bool) {
        shouldShowCountryDetails = shouldShow
    }

    func loadCountries() async {
        await updateState(.loading)
        do {
            let fetchedCountries = try await countryLoaderService.loadCountries(with: ["name", "flag", "region", "currency", "languages", "capital", "flags", "idd"])
            await updateCountries(fetchedCountries)
            await updateState(.loaded)
        } catch {
            print("Error while loading countries", error) //Log remote error
            await showAlert(true)
            await updateState(.initial)
        }
    }
}

enum LoadingState {
    case initial
    case loading
    case loaded
}
