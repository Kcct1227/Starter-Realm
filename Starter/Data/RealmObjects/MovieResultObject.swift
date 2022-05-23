//
//  MovieResultObject.swift
//  Starter
//
//  Created by KC on 30/03/2022.
//

import Foundation
import RealmSwift

class MovieResultObject : Object, ObjectKeyIdentifiable {
    @Persisted
    var adult: Bool?
    @Persisted
    var backdropPath: String?
    @Persisted
    var genreIDS: String?
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var runtime: Int?
    @Persisted
    var originalLanguage: String?
    @Persisted
    var originalTitle : String?
    @Persisted
    var originalName : String?
    @Persisted
    var overview: String?
    @Persisted
    var popularity: Double?
    @Persisted
    var posterPath: String?
    @Persisted
    var releaseDate : String?
    @Persisted
    var firstAirDate : String?
    @Persisted
    var title: String?
    @Persisted
    var video: Bool?
    @Persisted
    var voteAverage: Double?
    @Persisted
    var voteCount: Int?
    @Persisted
    var media_type: String?
    @Persisted
    var productionCompanies: List<ProductionCompanyObject>
    @Persisted
    var productionCountries: List<ProductionCountryObject>
    @Persisted
    var genres: List<MovieGenreObject>
    @Persisted
    var budget : Int?
    @Persisted
    var homepage : String?
    @Persisted
    var status : String?
    @Persisted
    var tagline : String?
    @Persisted
    var revenue : Int?
    @Persisted
    var imdbID : String?
    @Persisted
    var actors: List<ActorInfoResponseObject>
    @Persisted
    var similarContents: List<MovieResultObject>
    
    @Persisted
    var belongsToType: List<BelongsToTypeObject>

    
    func toSimilarContent()-> MovieListResult{
        let movies: [MovieResult] = similarContents.map{
            $0.toMovieResult()
        }
        
        return MovieListResult(dates: nil, page: 1, results: movies, totalPages: 1, totalResults: movies.count)
    }
    
    func toMovieCreditResponse()-> MovieCreditResponse{
        let actors : [ActorInfoResponse] = actors.map{
            $0.toActorInfoResponse()
        }
        let casts: [MovieCast] = actors.map{
            $0.toMovieCasts()
        }
        return MovieCreditResponse(id: id, cast: casts, crew: casts)
    }
    
    func toMovieResult()-> MovieResult{
        return MovieResult(adult: adult, backdropPath: backdropPath, genreIDS: genreIDS?.components(separatedBy: ",").compactMap{ Int($0.trimmingCharacters(in: .whitespaces)) }, id: id, originalLanguage: originalLanguage, originalTitle: originalTitle, originalName: originalName, overview: overview, popularity: popularity, posterPath: posterPath, releaseDate: releaseDate, title: title, firstAirDate: firstAirDate, video: video, voteAverage: voteAverage, voteCount: voteCount, media_type: media_type ?? ContentType.MovieType.rawValue, runtime: runtime)
    }
    
   
    
    func toMovieDetail()-> MovieDetailResponse{
        
        let genreList:[MovieGenre] = genres.map{
            $0.toMovieGenre()
        }
        
        let companyList:[ProductionCompany] = productionCompanies.map{
            $0.toProductionCompany()
        }
        
        let countryList:[ProductionCountry] = productionCountries.map{
            $0.toProductionCountry()
        }
        
        
        return MovieDetailResponse(adult: adult, backdropPath: backdropPath, belongsToCollection: nil, budget: budget, genres: genreList, homepage: homepage, id: id, imdbID: imdbID, originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: popularity, posterPath: posterPath, productionCompanies: companyList, productionCountries: countryList, releaseDate: releaseDate, revenue: revenue, runtime: runtime, spokenLanguages: nil, status: status, tagline: tagline, title: title, video: video, voteAverage: voteAverage, voteCount: voteCount, mediaType: media_type ?? ContentType.MovieType.rawValue)
    }
    
    func toSeriesDetail()-> SeriesDetailResponse{
        
        let genreList:[MovieGenre] = genres.map{
            $0.toMovieGenre()
        }
        
        let companyList:[ProductionCompany] = productionCompanies.map{
            $0.toProductionCompany()
        }
        
        let countryList:[ProductionCountry] = productionCountries.map{
            $0.toProductionCountry()
        }
        
        var rt : [Int] = [1]
        rt[0] = runtime ?? 0
        
        return SeriesDetailResponse(adult: adult, backdropPath: backdropPath, episodeRunTime: rt , firstAirDate: releaseDate, genres: genreList, homepage: homepage, id: id, inProduction: false, lastAirDate: releaseDate, name: title, originalLanguage: originalLanguage, originalName: originalTitle, overview: overview, popularity: popularity, posterPath: posterPath, productionCompanies: companyList, productionCountries: countryList, spokenLanguages: nil, status: status, tagline: tagline, voteAverage: voteAverage, voteCount: voteCount, mediaType: media_type ?? ContentType.SerieType.rawValue)
    }
    
   
}

