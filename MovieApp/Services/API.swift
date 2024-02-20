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
    case getMovieDetail(imdbId: String)
    
    var url: URL {
        switch self {
        case .searchMovies(let title):
            return URL(string: "\(URLConstants.baseURL)?s=\(title)&apikey=\(URLConstants.omdbAPIKey)")!
        case .getMovieDetail(let imdbId):
            return URL(string: "\(URLConstants.baseURL)?i=\(imdbId)&plot=full&apikey=\(URLConstants.omdbAPIKey)")!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchMovies:
            return .get
        case .getMovieDetail:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .searchMovies, .getMovieDetail:
            return nil
        }
    }
}
