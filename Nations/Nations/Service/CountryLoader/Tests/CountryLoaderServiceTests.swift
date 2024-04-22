//
//  CountryLoaderServiceTests.swift
//  NationsTests
//
//  Created by Nikhil Bhosale on 2024-04-21.
//

import XCTest
import Foundation
@testable import Nations

final class CountryLoaderServiceTests: XCTestCase {
    private var mockApiService: MockApiService!
    private var countryLoaderService: CountryLoaderService!

    override func setUpWithError() throws {
        mockApiService = MockApiService()
        countryLoaderService = CountryLoaderService(apiCountryLoaderService: mockApiService)
    }

    override func tearDownWithError() throws {
        mockApiService = nil
        countryLoaderService = nil
    }

    func testGetImage_whenImageIsDownloadedSuccessful_shouldBeCacheedInService() async {
        mockApiService.downloadFileCallCounter = 0
        _ = await countryLoaderService.getImage(with: "testUrl")
        XCTAssertTrue(mockApiService.downloadFileCallCounter == 1)
        _ = await countryLoaderService.getImage(with: "testUrl")
        XCTAssertTrue(mockApiService.downloadFileCallCounter == 1)
    }
}

final class MockApiService: APICountryLoaderServiceProtocol {
    var downloadFileCallCounter: Int = 0

    func loadCountries(with details: [String]) async throws -> [Country] {
        []
    }
    
    func downloadFile(for url: String) async throws -> Data {
        downloadFileCallCounter = +1
        return UIImage(named: "close")!.pngData()!
    }
}
