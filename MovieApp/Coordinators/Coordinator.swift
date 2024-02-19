//
//  Coordinator.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func start()
}
