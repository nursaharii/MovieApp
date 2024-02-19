//
//  MovieResponse.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation

struct MovieResponse: Decodable {
    let movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}
