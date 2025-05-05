//
//  CountryModel.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation

struct CountryModel: Codable, Equatable {
    let name: String
    let region: String
    let code: String
    let capital: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case code
        case capital
    }
    
    //making the model conform to equatable
    static func == (lhs: CountryModel, rhs: CountryModel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.region == rhs.region &&
        lhs.code == rhs.code &&
        lhs.capital == rhs.capital
    }
}
