//
//  APIManagerProtocol.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import Combine

protocol APIManagerProtocol {
    func fetchCountries() -> AnyPublisher<[CountryModel], NetworkError>
}
