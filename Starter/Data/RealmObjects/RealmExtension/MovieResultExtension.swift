//
//  MovieResultExtension.swift
//  Starter
//
//  Created by KC on 31/03/2022.
//

import Foundation
extension MovieResult {
    static func toMovieResultObject(movie: MovieResult) -> MovieResultObject{
        let object = MovieResultObject()
        object.adult  = movie.adult
        object.backdropPath = movie.backdropPath
        object.genreIDS = movie.genreIDS?.map { String($0)}.joined(separator: ",")
        object.id = movie.id
        object.runtime = movie.runtime
        object.originalLanguage = movie.originalLanguage
        object.originalTitle  = movie.originalTitle
        object.originalName  = movie.originalName
        object.overview = movie.overview
        object.popularity = movie.popularity
        object.posterPath = movie.posterPath
        object.releaseDate  = movie.releaseDate
        object.firstAirDate  = movie.firstAirDate
        object.title = movie.title
        object.video = movie.video
        object.voteAverage = movie.voteAverage
        object.voteCount = movie.voteCount
        object.media_type = movie.media_type
        
        return object
    }

}
