//
//  ActorEntityExtension.swift
//  Starter
//
//  Created by KC on 24/03/2022.
//

import Foundation
import CoreData

extension ActorEntity{
    
    static func toMovieCast(entity: ActorEntity) -> MovieCast{
        return MovieCast(
            adult: entity.adult,
            gender: Int(entity.gender),
            id: Int(entity.id),
            knownForDepartment: Department(rawValue: entity.knownForDepartment ?? ""),
            name: entity.name,
            originalName: entity.name,
            popularity: entity.popularity,
            profilePath: entity.profilePath,
            castID: 0,
            character: "Actor",
            creditID: "",
            order: 0,
            department: Department(rawValue: entity.knownForDepartment ?? ""),
            job: "")
    }
    
    static func toActorInfoResponse(entity: ActorEntity) -> ActorInfoResponse{
        return ActorInfoResponse(
            adult: entity.adult,
            gender: Int(entity.gender),
            id: Int(entity.id),
            knownFor: [MovieResult](),
            knownForDepartment: entity.knownForDepartment,
            name: entity.name,
            popularity: entity.popularity,
            profilePath: entity.profilePath
        )
    }
    
    static func toActorDetailResponse(entity: ActorEntity) -> ActorDetailResponse{
        return ActorDetailResponse(
            adult: entity.adult,
            alsoKnownAs: [String](),
            biography: entity.biography,
            birthday: entity.birthday,
            deathday: nil,
            gender: Int(entity.gender),
            homepage: entity.homepage,
            id: Int(entity.id),
            imdbID:  "",
            knownForDepartment: entity.knownForDepartment,
            name: entity.name,
            placeOfBirth: entity.placeOfBirth,
            popularity: entity.popularity,
            profilePath: entity.profilePath
        )
    }
}
