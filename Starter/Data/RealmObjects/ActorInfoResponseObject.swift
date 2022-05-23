//
//  MovieListResultObject.swift
//  Starter
//
//  Created by KC on 30/03/2022.
//

import Foundation
import RealmSwift

class ActorInfoResponseObject : Object{
    @Persisted
    var adult : Bool?
    @Persisted
    var gender: Int?
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var knownFor : List<MovieResultObject>
    @Persisted
    var knownForDepartment : String?
    @Persisted
    var name : String?
    @Persisted
    var popularity : Double?
    @Persisted
    var profilePath : String?
    @Persisted
    var homepage : String?
    @Persisted
    var birthday : String?
    @Persisted
    var biography : String?
    @Persisted
    var imdbID : String?
   
    
    func toActorInfoResponse() -> ActorInfoResponse{
        let movieList:[MovieResult] = knownFor.map{
            $0.toMovieResult()
        }
                
        return ActorInfoResponse(adult: adult, gender: gender, id: id, knownFor: movieList, knownForDepartment: knownForDepartment, name: name, popularity: popularity, profilePath: profilePath)
    }
    
    func toActorDetailResponse() -> ActorDetailResponse{
        return ActorDetailResponse(adult: adult, alsoKnownAs: nil, biography: biography, birthday: birthday, deathday: nil, gender: gender, homepage: homepage, id: id, imdbID: imdbID, knownForDepartment: knownForDepartment, name: name, placeOfBirth: "", popularity: popularity, profilePath: profilePath)
    }
}

