//
//  NetworkManager.swift
//  WalmartProject
//
//  Created by Arpit Mallick on 3/14/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badUrl
    case invalidResponse
    case other(String)
}

protocol NetworkService {
    func fetchData<T: Decodable>(from url: String) -> AnyPublisher<T, Error>
}

class WebApiManager: NetworkService {
    static let shared = WebApiManager()

    private init() {}

    func fetchData<T: Decodable>(from url: String) -> AnyPublisher<T, Error> {
        guard let apiUrl = URL(string: url) else {
            return Fail(error: NetworkError.badUrl)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: apiUrl)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return NetworkError.other(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
