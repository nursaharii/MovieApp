//
//  Movie.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation

struct Movie: Decodable {
    let title: String?
    let year: String?
    let imdbID: String?
    let type: String?
    let poster: String?
    let imdbRating: String?
    let plot: String?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
        case imdbRating = "imdbRating"
        case plot = "Plot"
        case language = "Language"
    }
}
