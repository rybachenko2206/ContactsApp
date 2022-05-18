//
//  APIMethod.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation

enum APIMethod {
    static let baseURL: URL = URL(string: "https://randomuser.me/api")!
    private static let requestItemsCount: Int = 20
    
    case getContactsList
    
    var httpMethod: String {
        switch self {
        case .getContactsList:
            return "GET"
        }
    }
    
    var url: URL? {
        switch self {
        case .getContactsList:
            return APIMethod.baseURL
        }
    }
    
    var headers: [String: String] {
        let headerFields: [String: String] = [
            "Content-Type": "application/json;charset=utf-8"
        ]
        
        return headerFields
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url,
            var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { return nil }
        
        if let params = requestParameters {
            // logic in this expression should be changed if some of new methods will be "POST"
            urlComp.queryItems = params.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        guard let finalUrl = urlComp.url else { return nil}
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    var requestParameters: [String: String]? {
        var parameters: [String: String] = [:]
        
        switch self {
        case .getContactsList:
            parameters["results"] = APIMethod.requestItemsCount.description
        }
        
        return parameters
    }
    
}

