//
//  SeriesDetailResponse.swift
//  Starter
//
//  Created by KC on 12/03/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let seriesDetailResponse = try? newJSONDecoder().decode(SeriesDetailResponse.self, from: jsonData)

import Foundation

// MARK: - SeriesDetailResponse
struct SeriesDetailResponse: Codable {
   
    
    let adult: Bool?
    let backdropPath: String?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [MovieGenre]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let lastAirDate: String?
    let name: String?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline : String?
    let voteAverage: Double?
    let voteCount: Int?
    let media_type: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case lastAirDate = "last_air_date"
        case name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
        case status, tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case media_type
    }
    
    init(adult: Bool?, backdropPath: String?, episodeRunTime: [Int]?, firstAirDate: String?, genres: [MovieGenre]?, homepage: String?, id: Int?, inProduction: Bool?, lastAirDate: String?, name: String?, originalLanguage: String?, originalName: String?, overview: String?, popularity: Double?, posterPath: String?, productionCompanies: [ProductionCompany]?, productionCountries: [ProductionCountry]?, spokenLanguages: [SpokenLanguage]?, status: String?, tagline: String?, voteAverage: Double?, voteCount: Int?, mediaType: String = ContentType.SerieType.rawValue) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.episodeRunTime = episodeRunTime
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.inProduction = inProduction
        self.lastAirDate = lastAirDate
        self.name = name
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.media_type = mediaType
    }
    
    
    func toMovieDetailResponse()->MovieDetailResponse{
        var runTime :Int = 0
        if let episodeRunTime = episodeRunTime {
            if episodeRunTime.count == 0{
                runTime = 0
            }
            else{
                runTime = episodeRunTime[0]
            }
        }
       
        return MovieDetailResponse(
            adult: adult,
            backdropPath: backdropPath,
            belongsToCollection: nil,
            budget: 0,
            genres: genres,
            homepage: homepage,
            id: id,
            imdbID: "",
            originalLanguage: originalLanguage,
            originalTitle: originalName,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            releaseDate: firstAirDate,
            revenue: nil,
            runtime: runTime,
            spokenLanguages: spokenLanguages,
            status: status,
            tagline: tagline,
            title: name,
            video: false,
            voteAverage: voteAverage,
            voteCount: voteCount,
            mediaType: ContentType.SerieType.rawValue
        )
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int?
    let creditID, name: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
}

// MARK: - TEpisodeToAir
struct TEpisodeToAir: Codable {
    let airDate: String?
    let episodeNumber, id: Int?
    let name, overview, productionCode: String?
    let seasonNumber: Int?
    let stillPath: String?
    let voteAverage, voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id, name, overview
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Network
struct Network: Codable {
    let name: String?
    let id: Int?
    let logoPath, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case name, id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}


// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount, id: Int?
    let name, overview, posterPath: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

//
//MARK: - Encode/decode helpers
//
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
