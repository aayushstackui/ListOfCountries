//
//  NetworkError.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided."
        case .noData:
            return "No data was received from the server."
        case .decodingError:
            return "Response decoding was failed."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.noData, .noData):
            return true
        case (.decodingError, .decodingError):
            return true
        case (.serverError(let lhsStatusCode), .serverError(let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
