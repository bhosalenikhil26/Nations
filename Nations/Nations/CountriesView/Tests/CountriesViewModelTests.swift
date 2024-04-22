//
//  CountriesViewModelTests.swift
//  NationsTests
//
//  Created by Nikhil Bhosale on 2024-04-21.
//

import XCTest
import SwiftUI
@testable import Nations

final class CountriesViewModelTests: XCTestCase {
    private var countriesViewModel: CountriesViewModel!
    private var countryLoaderService: MockCountryLoaderService!

    override func setUpWithError() throws {
        countryLoaderService = MockCountryLoaderService()
        countriesViewModel = CountriesViewModel(countryLoaderService: countryLoaderService)
    }

    override func tearDownWithError() throws {
        countryLoaderService = nil
        countriesViewModel = nil
    }

    func testDidTapRetry_whenLoadCountriesAPISucceeds_shouldUpdateStateToLoadedAndUpdateCountries() async {
        countryLoaderService.loadCountriesShouldFail = false
        XCTAssertTrue(countriesViewModel.loadingState == .initial)
        await countriesViewModel.didTapRetry()
        XCTAssertTrue(countriesViewModel.countries.count == 1)
        XCTAssertTrue(countriesViewModel.countries[0].flag == "flag")
        XCTAssertTrue(countriesViewModel.countries[0].name.common == "common")
        XCTAssertTrue(countriesViewModel.loadingState == .loaded)
        XCTAssertFalse(countriesViewModel.showAlert)
    }

    func testDidTapRetry_whenLoadCountriesAPIFails_shouldUpdateStateBackToInitialAndShowAlert() async {
        countryLoaderService.loadCountriesShouldFail = true
        XCTAssertTrue(countriesViewModel.loadingState == .initial)
        await countriesViewModel.didTapRetry()
        XCTAssertTrue(countriesViewModel.countries.count == 0)
        XCTAssertTrue(countriesViewModel.loadingState == .initial)
        XCTAssertTrue(countriesViewModel.showAlert)
    }
}

private final class MockCountryLoaderService: CountryLoaderServiceProtocol {
    var loadCountriesShouldFail: Bool = false

    func loadCountries(with details: [String]) async throws -> [Country] {
        guard !loadCountriesShouldFail else { throw APIError.couldNotParseToSpecifiedModel }
        return [
            Country(flags: APICountryLoaderService.FetchCountriesResponse.Flag(png: "pngUrl"),
                        name: APICountryLoaderService.FetchCountriesResponse.NameConfig(official: "offcial", common: "common"),
                        capital: ["capital"],
                        region: "region",
                        flag: "flag",
                    idd: APICountryLoaderService.FetchCountriesResponse.CountryCode(root: "+4", suffixes: ["6"]))
        ]
    }

    func getImage(with url: String) async -> Image? { nil }
}
