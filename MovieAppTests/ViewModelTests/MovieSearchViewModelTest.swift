//
//  MovieSearchViewModelTest.swift
//  MovieAppTests
//
//  Created by Nurşah Ari on 22.02.2024.
//

import XCTest
import Combine
@testable import MovieApp

class MovieSearchViewModelTests: XCTestCase {
    var viewModel: MovieSearchViewModel!
    var mockNetworkService: MockNetworkService!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = MovieSearchViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables = []
        super.tearDown()
    }
    
    func testSearchMoviesSuccess() {
        let json = """
                 {
                    "Search": [
                    {
                        "Title": "Test Movie",
                        "Year": "2020",
                        "imdbID": "tt1234567",
                        "Type": "movie",
                        "Poster": "url"
                    }
                    ],
                 "totalResults": "1",
                  "Response": "True"
                 }
                """
        
        viewModel.searchMovies(for: "Test")
        
        let expectation = XCTestExpectation(description: "Movies array should be populated")
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { movies in
                if !movies.isEmpty {
                    expectation.fulfill()
                    let jsonData = json.data(using: .utf8)
                    self.mockNetworkService.mockResponse = try! JSONDecoder().decode(MovieResponse.self, from: jsonData!)
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(mockNetworkService.mockResponse?.response, "True")
    }
    
    
    
    func testSearchMoviesFailure() {
        // Bir hata simüle et
        mockNetworkService.mockError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error occurred"])
        
        let expectation = XCTestExpectation(description: "Failed to fetch movies")
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { movies in
                if movies.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.errorMessage = { message in
            expectation.fulfill()
        }
        
        viewModel.searchMovies(for: "aaaaaaaaaaaaaa")
        
        wait(for: [expectation], timeout: 10.0)
    }
}
