//
//  MockAPIManager.swift
//  ListOfCountriesTests
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import Combine
@testable import ListOfCountries

class MockAPIManager: APIManagerProtocol {
    var result: Result<[CountryModel], NetworkError>?
    
    func fetchCountries() -> AnyPublisher<[CountryModel], NetworkError> {
        guard let result = result else {
            return Fail(error: NetworkError.unknown(NSError(domain: "", code: -1, userInfo: nil))).eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
