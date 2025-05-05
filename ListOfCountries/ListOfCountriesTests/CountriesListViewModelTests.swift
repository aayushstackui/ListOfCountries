//
//  CountriesListViewModelTests.swift
//  ListOfCountriesTests
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import XCTest
import Combine
@testable import ListOfCountries

class CountriesListViewModelTests: XCTestCase {
    var viewModel: CountriesListViewModel!
    var mockAPIManager: MockAPIManager!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = CountriesListViewModel(apiManager: mockAPIManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIManager = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchCountriesSuccess() {
        // arrange
        let countries = [
            CountryModel(name: "United States", region: "NA", code: "US", capital: "Washington, D.C."),
            CountryModel(name: "Canada", region: "NA", code: "CA", capital: "Ottawa")
        ]
        mockAPIManager.result = .success(countries)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch countries successfully")
        viewModel.$filteredCountries
            .dropFirst() // Skip initial empty state
            .sink { filteredCountries in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCountries()
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertEqual(viewModel.countries.count, 2, "Expected 2 countries, but got \(viewModel.countries.count)")
        XCTAssertEqual(viewModel.filteredCountries.count, 2, "Expected 2 filtered countries, but got \(viewModel.filteredCountries.count)")
        XCTAssertEqual(viewModel.countries.first?.name, "United States", "Expected first country to be United States")
        XCTAssertNil(viewModel.error, "Expected no error, but got \(viewModel.error?.localizedDescription ?? "nil")")
    }
    
    func testFetchCountriesFailure() {
        // arrange
        let expectedError = NetworkError.serverError(statusCode: 500)
        mockAPIManager.result = .failure(expectedError)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch countries fails with error")
        var receivedError: NetworkError?
        
        viewModel.$error
            .dropFirst() // Skip initial nil state
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCountries()
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertTrue(viewModel.countries.isEmpty, "Expected no countries, but got \(viewModel.countries)")
        XCTAssertTrue(viewModel.filteredCountries.isEmpty, "Expected no filtered countries, but got \(viewModel.filteredCountries)")
        XCTAssertNotNil(receivedError, "Expected an error, but got nil")
        XCTAssertEqual(receivedError, expectedError, "Expected server error with status code 500")
    }
    
    func testFilterCountriesByName() {
        // arrange
        let countries = [
            CountryModel(name: "United States", region: "NA", code: "US", capital: "Washington, D.C."),
            CountryModel(name: "Canada", region: "NA", code: "CA", capital: "Ottawa")
        ]
        viewModel.countries = countries
        viewModel.filteredCountries = countries
        
        // act
        viewModel.filterCountries(with: "United")
        
        // assertions
        XCTAssertEqual(viewModel.filteredCountries.count, 1, "Expected 1 filtered country, but got \(viewModel.filteredCountries.count)")
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "United States", "Expected United States, but got \(viewModel.filteredCountries.first?.name ?? "nil")")
    }
    
    func testFilterCountriesByCapital() {
        // arrange
        let countries = [
            CountryModel(name: "United States", region: "NA", code: "US", capital: "Washington, D.C."),
            CountryModel(name: "Canada", region: "NA", code: "CA", capital: "Ottawa")
        ]
        viewModel.countries = countries
        viewModel.filteredCountries = countries
        
        // act
        viewModel.filterCountries(with: "Ottawa")
        
        // assertions
        XCTAssertEqual(viewModel.filteredCountries.count, 1, "Expected 1 filtered country, but got \(viewModel.filteredCountries.count)")
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "Canada", "Expected Canada, but got \(viewModel.filteredCountries.first?.name ?? "nil")")
    }
    
    func testFilterCountriesWithEmptySearchText() {
        // arrange
        let countries = [
            CountryModel(name: "United States", region: "NA", code: "US", capital: "Washington, D.C."),
            CountryModel(name: "Canada", region: "NA", code: "CA", capital: "Ottawa")
        ]
        viewModel.countries = countries
        viewModel.filteredCountries = [countries[0]] // Simulate a previous filter
        
        // act
        viewModel.filterCountries(with: "")
        
        // assertions
        XCTAssertEqual(viewModel.filteredCountries.count, 2, "Expected 2 filtered countries, but got \(viewModel.filteredCountries.count)")
        XCTAssertEqual(viewModel.filteredCountries, countries, "Expected all countries to be shown")
    }
}
