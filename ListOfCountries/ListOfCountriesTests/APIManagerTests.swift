//
//  APIManagerTests.swift
//  ListOfCountriesTests
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import XCTest
import Combine
@testable import ListOfCountries

class APIManagerTests: XCTestCase {
    var apiManager: APIManager!
    var urlSession: URLSession!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        apiManager = APIManager(urlSession: urlSession)
        
        // here, we reset the URL before each test
        APIEndpoints.resetCountriesURL()
    }
    
    override func tearDown() {
        MockURLProtocol.testURLs.removeAll()
        apiManager = nil
        urlSession = nil
        cancellables.removeAll()
        APIEndpoints.resetCountriesURL()
        super.tearDown()
    }
    
    func testFetchCountriesSuccess() {
        // arrange
        let url = URL(string: APIEndpoints.countriesURL)!
        let sampleData = """
        [
            {"name": "United States", "region": "NA", "code": "US", "capital": "Washington, D.C."},
            {"name": "Canada", "region": "NA", "code": "CA", "capital": "Ottawa"}
        ]
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.testURLs[url] = (data: sampleData, response: response, error: nil)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch countries successfully")
        var result: [CountryModel]?
        var error: NetworkError?
        
        apiManager.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    error = err
                }
                expectation.fulfill()
            }, receiveValue: { countries in
                result = countries
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertNil(error, "Expected no error, but got \(error?.localizedDescription ?? "nil")")
        XCTAssertNotNil(result, "Expected countries, but got nil")
        XCTAssertEqual(result?.count, 2, "Expected 2 countries, but got \(result?.count ?? 0)")
        XCTAssertEqual(result?.first?.name, "United States", "Expected first country to be United States")
    }
    
    func testFetchCountriesServerError() {
        // arrange
        let url = URL(string: APIEndpoints.countriesURL)!
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.testURLs[url] = (data: nil, response: response, error: nil)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch countries fails with server error")
        var error: NetworkError?
        
        apiManager.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    error = err
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertNotNil(error, "Expected an error, but got nil")
        XCTAssertEqual(error, NetworkError.serverError(statusCode: 500), "Expected serverError with status code 500, but got \(error?.localizedDescription ?? "nil")")
    }
    
    func testFetchCountriesDecodingError() {
        // arrange
        let url = URL(string: APIEndpoints.countriesURL)!
        let invalidData = "invalid json".data(using: .utf8)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.testURLs[url] = (data: invalidData, response: response, error: nil)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch countries fails with decoding error")
        var error: NetworkError?
        
        apiManager.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    error = err
                }
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertNotNil(error, "Expected an error, but got nil")
        XCTAssertEqual(error, NetworkError.decodingError, "Expected decodingError, but got \(error?.localizedDescription ?? "nil")")
    }
    
    func testFetchCountriesEmptyResponse() {
        // arrange
        let url = URL(string: APIEndpoints.countriesURL)!
        let emptyData = "[]".data(using: .utf8)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.testURLs[url] = (data: emptyData, response: response, error: nil)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch empty countries list successfully")
        var result: [CountryModel]?
        var error: NetworkError?
        
        apiManager.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    error = err
                }
                expectation.fulfill()
            }, receiveValue: { countries in
                result = countries
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertNil(error, "Expected no error, but got \(error?.localizedDescription ?? "nil")")
        XCTAssertNotNil(result, "Expected countries array, but got nil")
        XCTAssertEqual(result?.count, 0, "Expected 0 countries, but got \(result?.count ?? 0)")
    }
    
    func testFetchCountriesSingleCountry() {
        // arrange
        let url = URL(string: APIEndpoints.countriesURL)!
        let singleCountryData = """
        [
            {"name": "Japan", "region": "Asia", "code": "JP", "capital": "Tokyo"}
        ]
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.testURLs[url] = (data: singleCountryData, response: response, error: nil)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch single country successfully")
        var result: [CountryModel]?
        var error: NetworkError?
        
        apiManager.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    error = err
                }
                expectation.fulfill()
            }, receiveValue: { countries in
                result = countries
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertNil(error, "Expected no error, but got \(error?.localizedDescription ?? "nil")")
        XCTAssertNotNil(result, "Expected countries array, but got nil")
        XCTAssertEqual(result?.count, 1, "Expected 1 country, but got \(result?.count ?? 0)")
        XCTAssertEqual(result?.first?.name, "Japan", "Expected country to be Japan")
        XCTAssertEqual(result?.first?.region, "Asia", "Expected region to be Asia")
        XCTAssertEqual(result?.first?.code, "JP", "Expected code to be JP")
        XCTAssertEqual(result?.first?.capital, "Tokyo", "Expected capital to be Tokyo")
    }
    
    func testFetchCountriesNetworkError() {
        // arrange
        let url = URL(string: APIEndpoints.countriesURL)!
        let networkError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedDescriptionKey: "Not connected to the internet"])
        MockURLProtocol.testURLs[url] = (data: nil, response: nil, error: networkError)
        
        // act
        let expectation = XCTestExpectation(description: "Fetch countries fails with network error")
        var error: NetworkError?
        
        apiManager.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    error = err
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // assertions
        XCTAssertNotNil(error, "Expected an error, but got nil")
        if case .unknown(let underlyingError) = error {
            XCTAssertEqual(underlyingError._code, NSURLErrorNotConnectedToInternet, "Expected network error with code \(NSURLErrorNotConnectedToInternet), but got \(underlyingError._code)")
        } else {
            XCTFail("Expected NetworkError.unknown, but got \(error?.localizedDescription ?? "nil")")
        }
    }
}
