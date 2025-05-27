//
//  CountryViewModel.swift
//  WalmartProject
//
//  Created by Arpit Mallick on 3/16/25.
//
import Foundation
import Combine

class CountryViewModel {
    private let apiService: NetworkService
    private var cancellable: AnyCancellable?

    var countries: [CountryModel] = []
    var filteredCountries: [CountryModel] = []
    var onDataUpdated: (() -> Void)?

    init(apiService: NetworkService = WebApiManager.shared) {
        self.apiService = apiService
    }

    func fetchCountries() {
        cancellable = apiService.fetchData(from: ApiConstants.apiUrl)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.countries = []
                    self.filteredCountries = []
                    print("Error fetching data: \(error.localizedDescription)")
                case .finished:
                    break
                }
                self.onDataUpdated?()
            }, receiveValue: { countries in
                self.countries = countries
                self.filteredCountries = countries
            })
    }

    func searchCountries(query: String) {
        filteredCountries = query.isEmpty
            ? countries
            : countries.filter {
                $0.name.lowercased().contains(query.lowercased()) ||
                $0.capital.lowercased().contains(query.lowercased())
              }
        onDataUpdated?()
    }

    func numberOfRows() -> Int {
        return filteredCountries.isEmpty ? 1 : filteredCountries.count
    }

    func country(at index: Int) -> CountryModel? {
        return index < filteredCountries.count ? filteredCountries[index] : nil
    }
}
