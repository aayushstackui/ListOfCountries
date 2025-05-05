//
//  APIManager.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import Combine

class APIManager: APIManagerProtocol {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func fetchCountries() -> AnyPublisher<[CountryModel], NetworkError> {
        guard let url = URL(string: APIEndpoints.countriesURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknown(NSError(domain: "", code: -1, userInfo: nil))
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }

                return data
            }
            .decode(type: [CountryModel].self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingError
                } else {
                    return NetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
