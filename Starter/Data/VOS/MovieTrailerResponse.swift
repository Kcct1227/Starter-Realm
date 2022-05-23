//
//  MovieTrailerResponse.swift
//  Starter
//
//  Created by KC on 15/03/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieTrailerResponse = try? newJSONDecoder().decode(MovieTrailerResponse.self, from: jsonData)

import Foundation

// MARK: - MovieTrailerResponse
struct MovieTrailerResponse: Codable {
    
    let id: Int?
    let results: [MovieTrailer]?
    
    public init(id: Int?, results: [MovieTrailer]?) {
        self.id = id
        self.results = results
    }
}

// MARK: - MovieTrailer
struct MovieTrailer: Codable {
    
    let iso639_1, iso3166_1, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
    
    public init(iso639_1: String?, iso3166_1: String?, name: String?, key: String?, site: String?, size: Int?, type: String?, official: Bool?, publishedAt: String?, id: String?) {
        self.iso639_1 = iso639_1
        self.iso3166_1 = iso3166_1
        self.name = name
        self.key = key
        self.site = site
        self.size = size
        self.type = type
        self.official = official
        self.publishedAt = publishedAt
        self.id = id
    }
}
