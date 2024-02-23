//
//  MovieDetailViewModelTests.swift
//  MovieAppTests
//
//  Created by Nurşah Ari on 23.02.2024.
//

import XCTest
import Combine
@testable import MovieApp

class MockURLHandler: URLHandler {
    var lastURL: URL?
    
    func openURL(_ url: URL) {
        lastURL = url
    }
}

class MovieDetailViewModelTests: XCTest {
    var viewModel: MovieDetailViewModel!
    
    func testGoToIMDBPage() {
        let mockURLHandler = MockURLHandler()
        viewModel.goToIMDBPage("tt0111161")
        XCTAssertEqual(mockURLHandler.lastURL, URL(string: "https://www.imdb.com/title/tt0111161"))
    }
    
}
