//
//  CountryLoaderServiceTests.swift
//  NationsTests
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import XCTest
@testable import Nations

final class APICountryLoaderServiceTests: XCTestCase {
    private var mockAPIRequest: MockAPIRequest!
    private var apiService: APICountryLoaderService!

    override func setUpWithError() throws {
        mockAPIRequest = MockAPIRequest()
        apiService = APICountryLoaderService()
    }

    override func tearDownWithError() throws {
        mockAPIRequest = nil
        apiService = nil
    }

    func testExecuteRequest_whenURLIsNotPresent_shouldThrowInvalidUrlError() async {
        mockAPIRequest.url = nil
        do {
            _ = try await apiService.executeApiRequest(mockAPIRequest)
            XCTFail()
        } catch let error as APIError {
            XCTAssertTrue(error == APIError.invalidUrl)
        } catch {
            XCTFail()
        }
    }

    func testExecuteRequest_whenURLIsValid_shouldCallAPI() async {
        mockAPIRequest.url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags")
        do {
            let data = try await apiService.executeApiRequest(mockAPIRequest)
            XCTAssertNotNil(data)
        } catch {
            XCTFail()
        }
    }
}

private final class MockAPIRequest: APIRequest {
    var url: URL?
}
