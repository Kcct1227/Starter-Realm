//
//  SearchMovieList.swift
//  NetworkTesting
//
//  Created by KC on 10/03/2022.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchMovieVo = try? newJSONDecoder().decode(SearchMovieVo.self, from: jsonData)

import Foundation

// MARK: - SearchMovieVO
struct SearchMovieVO: Codable {
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
