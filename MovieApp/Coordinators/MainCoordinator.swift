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
    
    func showMovieDetail(_ movieId: String) {
        let detailVC = MovieDetailViewController()
        detailVC.movieId = movieId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
