//
//  MockApiManager.swift
//  WalmartProject
//
//  Created by Arpit Mallick on 5/22/25.
//

import Foundation
import Combine
@testable import WalmartProject

enum NetworkError: Error {
    case badUrl
    case invalidResponse
    case parsingError
    case other(String)
}

class MockApiManager: NetworkService {
    
    enum MockErrorType {
        case invalidResponse
        case badUrl
        case parsingError
        case success
    }
    
    private let errorType: MockErrorType

    init(errorType: MockErrorType = .success) {
        self.errorType = errorType
    }

    func fetchData<T: Decodable>(from url: String) -> AnyPublisher<T, Error> {
        switch errorType {
        case .invalidResponse:
            return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
            
        case .badUrl:
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
            
        case .parsingError:
            let invalidJson = """
            {
                "invalid": "data"
            }
            """
            guard let jsonData = invalidJson.data(using: .utf8) else {
                return Fail(error: NetworkError.other("Failed to encode mock JSON")).eraseToAnyPublisher()
            }
            return Just(jsonData)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { _ in NetworkError.parsingError }
                .eraseToAnyPublisher()
            
        case .success:
            guard let path = Bundle(for: MockApiManager.self).path(forResource: "MockCountries", ofType: "json"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
            }
            return Just(data)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in NetworkError.other(error.localizedDescription) }
                .eraseToAnyPublisher()
        }
    }
}
