//
//  MainCoordinator.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?

    func start() {
        let vc = MovieSearchViewController()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func showMovieDetail(movie: Movie) {
        let detailVC = MovieDetailViewController()
        detailVC.movie = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
