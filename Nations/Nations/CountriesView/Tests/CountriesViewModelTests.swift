//
//  CountriesViewModelTests.swift
//  NationsTests
//
//  Created by Nikhil Bhosale on 2024-04-21.
//

import XCTest
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
        XCTAssertTrue(countriesViewModel.countriesWithFlag.count == 1)
        XCTAssertTrue(countriesViewModel.countriesWithFlag[0].flag == "flag")
        XCTAssertTrue(countriesViewModel.countriesWithFlag[0].name == "country")
        XCTAssertTrue(countriesViewModel.loadingState == .loaded)
        XCTAssertFalse(countriesViewModel.showAlert)
    }

    func testDidTapRetry_whenLoadCountriesAPIFails_shouldUpdateStateBackToInitialAndShowAlert() async {
        countryLoaderService.loadCountriesShouldFail = true
        XCTAssertTrue(countriesViewModel.loadingState == .initial)
        await countriesViewModel.didTapRetry()
        XCTAssertTrue(countriesViewModel.countriesWithFlag.count == 0)
        XCTAssertTrue(countriesViewModel.loadingState == .initial)
        XCTAssertTrue(countriesViewModel.showAlert)
    }
}

private final class MockCountryLoaderService: CountryLoaderServiceProtocol {
    var loadCountriesShouldFail: Bool = false

    func loadCountries(with details: [String]) async throws -> [Country] {
        guard !loadCountriesShouldFail else { throw APIError.couldNotParseToSpecifiedModel }
        return [Country(flags: APICountryLoaderService.FetchCountriesResponse.Flag(svg: "svgUrl", alt: "description")
                        , name: APICountryLoaderService.FetchCountriesResponse.NameConfig(common: "country", official: "offcialCountry"),
                        capital: ["capital"],
                        region: "Region",
                        flag: "flag")]
    }
}
