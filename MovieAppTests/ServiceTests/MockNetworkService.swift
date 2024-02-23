//
//  MockNetworkService.swift
//  MovieAppTests
//
//  Created by Nurşah Ari on 22.02.2024.
//

import Foundation
import Combine

class MockNetworkService: NetworkService {
    var mockResponse: MovieResponse?
    var mockError: Error?
    
    func fetchResource(from endpoint: API) -> AnyPublisher<MovieResponse, Error> {
        if let mockError = mockError {
            return Fail(error: mockError).eraseToAnyPublisher()
        }
        return Just(mockResponse!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }}
