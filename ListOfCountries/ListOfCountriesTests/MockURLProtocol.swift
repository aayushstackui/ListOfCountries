//
//  MockURLProtocol.swift
//  ListOfCountriesTests
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var testURLs = [URL: (data: Data?, response: HTTPURLResponse?, error: Error?)]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url, let (data, response, error) = MockURLProtocol.testURLs[url] else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
