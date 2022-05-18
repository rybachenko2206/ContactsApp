//
//  AppError.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation

enum AppError: Error, LocalizedError {
    case custom(String)
    case sessionExpired
    case unauthorized
    case defaultError
    case notFound
    case noResponse
    case connectionLost
    case internalServerError
    case serverUnavailable
    case parseResponseModel(String?)
    case stubFileNotFound
    case mocInDecodable
    
    init(serverError: ServerError) {
        self = .custom(serverError.errorMessage)
    }
    
    init(error: Error?, statusCode: Int? = nil) {
        guard let code = statusCode, code >= 0 else {
            if let err = error {
                self = .custom(err.localizedDescription)
            } else {
                self = .defaultError
            }
            return
        }
        
        switch code {
        case 401: self = .sessionExpired
        case 403:  self = .unauthorized
        case 404: self = .notFound
        case 500: self = .internalServerError
        case 503: self = .serverUnavailable
        case -1001: self = .noResponse
        default:
            self = .defaultError
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .custom(let message):
            return message
        case .sessionExpired:
            return "Your session is expired.."
        case .unauthorized:
            return "Authorization required"
        case .defaultError:
            return "Something went wrong. Try again later"
        case .notFound:
            return "resource is not found"
        case .noResponse:
            return "The server is not responding"
        case .internalServerError:
            return "Internal server error"
        case .serverUnavailable:
            return "Server is currently anavailable. Please, try again later"
        case .parseResponseModel(let errorInfo):
            return "Decoding Error: \(errorInfo ?? "no information")"
        case .connectionLost:
            return "Network connection lost. Check you connection and try again"
        case .stubFileNotFound:
            return "Stub file is not found"
        case .mocInDecodable:
            return "get context in init with decoder error"
        }
    }
}
