//
//  ActorInfoResponseExtension.swift
//  Starter
//
//  Created by KC on 31/03/2022.
//

import Foundation
import RealmSwift

extension ActorInfoResponse{
    static func toActorDetailResponseObject(data: ActorInfoResponse) -> ActorInfoResponseObject{
        let object = ActorInfoResponseObject()
        object.id = data.id
        object.adult = data.adult
        object.profilePath = data.profilePath
        object.knownForDepartment =  "Acting"
        object.popularity = data.popularity
        object.gender  = data.gender
        object.name = data.name
        object.homepage = ""
        object.birthday = ""
        object.biography = ""
        object.imdbID = ""
        let moives = List<MovieResultObject>()
        data.knownFor?.forEach{
            moives.append(MovieResult.toMovieResultObject(movie: $0))
            
        }
        object.knownFor = moives
        
        return object
        
    }
    
}
