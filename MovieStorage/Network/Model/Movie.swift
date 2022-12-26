//
//  Movie.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/24.
//

import Foundation

struct MovieResponse: Codable {
    let search: [Movie]?
    let totalResults: String?
    let response: String
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

struct Movie: Codable, Hashable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
