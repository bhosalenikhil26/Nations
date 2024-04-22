//
//  APICountryLoaderService.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum APICountryRequest: APIRequest {
    case fetchCountries(request: APICountryLoaderService.FetchCountriesRequest)
    case downloadFile(url: String)

    var baseURLPath: String {
        switch self {
        case .fetchCountries: return ServerEnvironment.serverUrl
        case .downloadFile: return ""
        }
    }

    var path: String {
        switch self {
        case .fetchCountries: return "v3.1/all"
        case .downloadFile(let url): return url
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchCountries, .downloadFile: return .get
        }
    }

    var queryParameters: [String: String?]? {
        switch self {
        case .fetchCountries(let request): return ["fields": request.details.map { $0 }.joined(separator: ",")]
        case .downloadFile: return nil
        }
    }

    var url: URL? {
        guard var urlComponents = URLComponents(string: baseURLPath + path) else { return nil }
        if urlComponents.queryItems == nil || urlComponents.queryItems?.isEmpty == true {
            urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0, value: $1) }
        } else if let queryParams = queryParameters, var queryItems = urlComponents.queryItems {
            queryItems.append(contentsOf: queryParams.map { URLQueryItem(name: $0, value: $1) })
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else { return nil }
        return url
    }
}

