//
//  CountriesListViewModel.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import Combine

class CountriesListViewModel {
    private let apiManager: APIManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var countries: [CountryModel] = []
    @Published var filteredCountries: [CountryModel] = []
    @Published var error: NetworkError?
    @Published var viewMode: ViewMode = .list 
    
    enum ViewMode: String {
        case list = "List"
        case grid = "Grid"
    }
    
    init(apiManager: APIManagerProtocol = APIManager(urlSession: .shared)) {
        self.apiManager = apiManager
    }
    
    func fetchCountries() {
        apiManager.fetchCountries()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] countries in
                self?.countries = countries
                self?.filteredCountries = countries
            }
            .store(in: &cancellables)
    }
    
    func filterCountries(with searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { country in
                country.name.lowercased().contains(searchText.lowercased()) ||
                country.capital.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
