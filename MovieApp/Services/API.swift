//
//  API.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation
import Alamofire

enum API {
    case searchMovies(title: String)
    case createMovie(title: String, description: String)

    var url: URL {
        switch self {
        case .searchMovies(let title):
            return URL(string: "\(URLConstants.baseURL)?s=\(title)&apikey=\(URLConstants.omdbAPIKey)")!
        case .createMovie:
            return URL(string: "https://api.example.com/movies")!
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchMovies:
            return .get
        case .createMovie:
            return .post
        }
    }

    // `createMovie` için kullanılacak gövde parametreleri
    var parameters: Parameters? {
        switch self {
        case .searchMovies:
            return nil
        case .createMovie(let title, let description):
            return ["title": title, "description": description]
        }
    }
}
