//
//  MovieResponse.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation

struct MovieResponse: Codable {
    let movieInfo: [MovieInfo]?
    let totalResults: String?
    let response: String?
    let error: String?

    private enum CodingKeys: String, CodingKey {
        case movieInfo = "Search"
        case totalResults = "totalResults"
        case response = "Response"
        case error = "Error"
    }
}

struct MovieInfo: Codable {
    let title: String?
    let year: String?
    let imdbID: String?
    let type: String?
    let poster: String?
    

    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
