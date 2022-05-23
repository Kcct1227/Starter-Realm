//
//  MovieEntityExtension.swift
//  Starter
//
//  Created by KC on 23/03/2022.
//

import Foundation
import CoreData

extension MovieEntity{
    
    static func toMovieResult(entity: MovieEntity) -> MovieResult{
        return MovieResult(
            adult: entity.adult,
            backdropPath: entity.backdropPath,
            genreIDS: entity.genreIDs?.components(separatedBy: ",").compactMap{ Int($0.trimmingCharacters(in: .whitespaces)) },
            id: Int(entity.id),
            originalLanguage: entity.originalLanguage,
            originalTitle: entity.originalTitle,
            originalName: entity.originalName,
            overview: entity.overview,
            popularity: entity.popularity,
            posterPath: entity.posterPath,
            releaseDate: entity.releaseDate,
            title: entity.title,
            firstAirDate: entity.releaseDate,
            video: entity.video,
            voteAverage: entity.voteAverage,
            voteCount: Int(entity.voteCount),
            media_type: entity.mediaType ?? ContentType.MovieType.rawValue,
            runtime: Int(entity.runTime)
        )
    }
    
    static func toMovieDetailResponse(entity: MovieEntity, companyList: [ProductionCompany], countryList: [ProductionCountry]) -> MovieDetailResponse{

        return MovieDetailResponse(
            adult: entity.adult,
            backdropPath: entity.backdropPath,
            belongsToCollection: nil,
            budget: 0,
            genres:  entity.genreIDs?.components(separatedBy: ",").compactMap{
                MovieGenre(id: 0, name: $0.trimmingCharacters(in: .whitespaces))
            },
            homepage: entity.homePage ,
            id: Int(entity.id),
            imdbID: entity.imdbID,
            originalLanguage: entity.originalLanguage,
            originalTitle: entity.originalTitle ,
            overview: entity.overview ,
            popularity: entity.popularity ,
            posterPath: entity.posterPath,
            productionCompanies: companyList,
            productionCountries: countryList,
            releaseDate: entity.releaseDate,
            revenue: 0,
            runtime: Int(entity.runTime),
            spokenLanguages: nil,
            status: "",
            tagline: "",
            title: entity.title,
            video: entity.video,
            voteAverage: entity.voteAverage,
            voteCount: Int(entity.voteCount)
            
        )
    }
    
   
}
