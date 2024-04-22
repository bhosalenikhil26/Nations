//
//  CountryDetailsViewModelTests.swift
//  NationsTests
//
//  Created by Nikhil Bhosale on 2024-04-22.
//

import XCTest
import SwiftUI
@testable import Nations

final class CountryDetailsViewModelTests: XCTestCase {
    private var countryDetailsViewModel: CountryDetailsViewModel!
    private var countryLoaderService: MockCountryLoaderService!

    override func setUpWithError() throws {
        countryLoaderService = MockCountryLoaderService()

    }

    override func tearDownWithError() throws {
        countryLoaderService = nil
        countryDetailsViewModel = nil
    }

    func testCountryCode_whenOnlyOneSuffixIsPresentInIdd_shouldReturnCountryCodeWithAppendingSuffixToRoot() {
        countryDetailsViewModel = CountryDetailsViewModel(country: getCountry(shouldHaveMultipleIddSuffix: false), countryLoaderService: countryLoaderService)
        XCTAssertTrue(countryDetailsViewModel.countryCode == "+46")
    }

    func testCountryCode_whenMultipleSuffixesArePresentInIdd_shouldReturnRootRootAsCountryCode() {
        countryDetailsViewModel = CountryDetailsViewModel(country: getCountry(shouldHaveMultipleIddSuffix: true), countryLoaderService: countryLoaderService)
        XCTAssertTrue(countryDetailsViewModel.countryCode == "+4")
    }

    func getCountry(shouldHaveMultipleIddSuffix: Bool = false) -> Country {
        Country(flags: APICountryLoaderService.FetchCountriesResponse.Flag(png: "pngUrl"),
                name: APICountryLoaderService.FetchCountriesResponse.NameConfig(official: "offcial", common: "common"),
                capital: ["capital"],
                region: "region",
                flag: "flag",
                idd: APICountryLoaderService.FetchCountriesResponse.CountryCode(root: "+4", suffixes:shouldHaveMultipleIddSuffix ? ["6", "7"] : ["6"]))
    }
}

private final class MockCountryLoaderService: CountryLoaderServiceProtocol {
    var loadCountriesShouldFail: Bool = false

    func loadCountries(with details: [String]) async throws -> [Country] { [] }
    func getImage(with url: String) async -> Image? { nil }
}
