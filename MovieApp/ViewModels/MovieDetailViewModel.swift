//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Nurşah Ari on 19.02.2024.
//

import Foundation
import Combine
import UIKit

class MovieDetailViewModel {
    
    @Published var movie : Movie?
    var errorMessage: ((String?) -> Void)?
    private var cancellables: Set<AnyCancellable> = []
    private var networkService = NetworkService()
    private var urlHandler: URLHandler
    
    init(urlHandler: URLHandler = ApplicationURLHandler()) {
        self.urlHandler = urlHandler
    }
    
    func getMovieDetail(for id: String) {
        
        networkService.fetchResource(from: .getMovieDetail(imdbId: id))
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage?("An error occurred: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (response: Movie) in
                guard let self = self else { return }
                self.movie = response
            })
            .store(in: &cancellables)
    }
    
    func goToIMDBPage(_ imdbId: String) {
        if let url = URL(string: URLConstants.imdbURL+imdbId), UIApplication.shared.canOpenURL(url) {
            urlHandler.openURL(url)
        }
    }
}

