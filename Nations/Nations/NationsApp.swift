//
//  NationsApp.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

@main
struct NationsApp: App {
    var body: some Scene {
        WindowGroup {
            CountriesView(viewModel: getCountriesModel())
        }
    }

    private func getCountriesModel() -> CountriesViewModel {
        CountriesViewModel(countryLoaderService: CountryLoaderService(apiCountryLoaderService: APICountryLoaderService()))
    }
}
