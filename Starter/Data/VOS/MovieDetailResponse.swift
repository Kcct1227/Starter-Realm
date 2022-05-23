//
//  MovieDetailResponse.swift
//  Starter
//
//  Created by KC on 11/03/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailResponse = try? newJSONDecoder().decode(MovieDetailResponse.self, from: jsonData)

import Foundation
import CoreData
// MARK: - MovieDetailResponse
struct MovieDetailResponse: Codable {
    
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [MovieGenre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let media_type: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case media_type
    }
    
    init(adult: Bool?, backdropPath: String?, belongsToCollection: BelongsToCollection?, budget: Int?, genres: [MovieGenre]?, homepage: String?, id: Int?, imdbID: String?, originalLanguage: String?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, productionCompanies: [ProductionCompany]?, productionCountries: [ProductionCountry]?, releaseDate: String?, revenue: Int?, runtime: Int?, spokenLanguages: [SpokenLanguage]?, status: String?, tagline: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?, mediaType: String = ContentType.MovieType.rawValue) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.belongsToCollection = belongsToCollection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdbID = imdbID
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.media_type = mediaType
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity{
        let entity = MovieEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        var genreListStr = ""
        genres?.forEach({ (item) in
            genreListStr += "\(item.name ), "
        })
        entity.runTime = Int32(runtime ?? 0)
        entity.genreIDs = genreListStr
        entity.originalLanguage = originalLanguage
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0.0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.mediaType = media_type
        return entity
    }
    
    func toSeriesDetailResonse()-> SeriesDetailResponse{
        var rt : [Int] = [1]
        rt[0] = runtime ?? 0
        return SeriesDetailResponse(
            adult: adult,
            backdropPath: backdropPath,
            episodeRunTime: rt,
            firstAirDate: releaseDate,
            genres: genres,
            homepage: "",
            id: id,
            inProduction: false,
            lastAirDate: releaseDate,
            name: title,
            originalLanguage: originalLanguage,
            originalName: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: nil,
            status: status,
            tagline: tagline,
            voteAverage: voteAverage,
            voteCount: voteCount,
            mediaType: media_type ?? ContentType.SerieType.rawValue
        
        )
    }
    
    
    static func empty() -> MovieDetailResponse{
        return MovieDetailResponse(adult: nil, backdropPath: nil, belongsToCollection: nil, budget: nil, genres: nil, homepage: nil, id: nil, imdbID: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: nil, productionCompanies: nil, productionCountries: nil, releaseDate: nil, revenue: nil, runtime: nil, spokenLanguages: nil, status: nil, tagline: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil)
    }
    
   
    
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    func toMovieProductonCompany(conext: NSManagedObjectContext) -> ProductionCompanyEntity{
        let entity = ProductionCompanyEntity(context: conext)
        entity.id = Int32(id ?? 0)
        entity.logoPath = logoPath
        entity.name = name
        entity.originCountry = originCountry
        return entity
    }
   
    
}


// MARK: - ProductionCountry
public struct ProductionCountry: Codable {
    public let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
    func toMovieProductionCountry(context: NSManagedObjectContext) -> ProductionCountryEntity{
        let entity = ProductionCountryEntity(context: context)
        entity.iso3166_1 = iso3166_1
        entity.name = name
        return entity
    }
}

// MARK: - SpokenLanguage
public struct SpokenLanguage: Codable {
   public  let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
