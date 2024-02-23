//
//  MovieSearchViewModel.swift
//  MovieApp
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation
import Combine

class MovieSearchViewModel {
    @Published var movies: [MovieInfo] = []
    var errorMessage: ((String?) -> Void)?
    
    private var cancellables: Set<AnyCancellable> = []
    private var networkService = NetworkService()
    
    var searchTerm: String = "" {
        didSet {
            searchMovies(for: searchTerm)
        }
    }
    
    init() {
        // ViewModel initialization
    }
    
    func searchMovies(for term: String) {
        guard !term.isEmpty else {
            return
        }
        
        networkService.fetchResource(from: .searchMovies(title: term))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage?("An error occurred: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (response: MovieResponse) in
                if let movies = response.movieInfo {
                    self?.movies = movies
                }
            })
            .store(in: &cancellables)
    }
    
    func emptyList() {
        movies.removeAll()
        cancellables.removeAll()
    }
}

