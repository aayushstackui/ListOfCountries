//
//  APIEndpoints.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation

enum APIEndpoints {
    private static let defaultCountriesURL = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    private static var _countriesURL: String = defaultCountriesURL
    
    static var countriesURL: String {
        get { _countriesURL }
        set { _countriesURL = newValue }
    }
    
    // resetting to default for tests
    static func resetCountriesURL() {
        _countriesURL = defaultCountriesURL
    }
}
