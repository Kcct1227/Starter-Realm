//
//  UpComingMovieList.swift
//  NetworkTesting
//
//  Created by KC on 10/03/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upComingMovieList = try? newJSONDecoder().decode(UpComingMovieList.self, from: jsonData)

import Foundation
import UIKit
import CoreData

// MARK: - UpComingMovieList
struct MovieListResult: Codable {
    let dates: Dates?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    public init(dates: Dates?, page: Int?, results: [MovieResult]?, totalPages: Int?, totalResults: Int?){
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    static func empty() -> MovieListResult {
        MovieListResult(dates: nil, page: nil, results: nil, totalPages: nil, totalResults: nil)
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - MovieResult
struct MovieResult: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let runtime: Int?
    let originalLanguage: String?
    let originalTitle, originalName, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, firstAirDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let media_type: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case runtime
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case media_type
        
    }
    
    init(adult:Bool?,backdropPath: String?, genreIDS: [Int]?, id: Int?, originalLanguage: String?, originalTitle: String?,originalName : String?, overview:String?, popularity: Double?,posterPath:String?, releaseDate:String?,title:String?, firstAirDate: String?, video:Bool?, voteAverage: Double?, voteCount:Int?, media_type: String = ContentType.MovieType.rawValue, runtime: Int?){
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.runtime = runtime
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.firstAirDate = firstAirDate
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.media_type = media_type
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext, groupTye: BelongsToTypeEntity) -> MovieEntity{
        let entity = MovieEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genreIDS?.map { String($0)}.joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalName
        entity.runTime = Int32(runtime ?? 0)
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0.0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? firstAirDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.mediaType = media_type
        entity.addToBelongsToType(groupTye)
        return entity
    }
    
    
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case ja = "ja"
}
