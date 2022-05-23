//
//  ActorInfoResponse.swift
//  Starter
//
//  Created by KC on 16/03/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorInfoResponse = try? newJSONDecoder().decode(ActorInfoResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - ActorInfoResponse
struct ActorDetailResponse: Codable {
    let adult: Bool?
    let alsoKnownAs: [String]?
    let biography, birthday: String?
    let deathday: JSONNull?
    let gender: Int?
    let homepage: String?
    let id: Int?
    let imdbID, knownForDepartment, name, placeOfBirth: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    @discardableResult
    func toActorEntity(context: NSManagedObjectContext) -> ActorEntity{
        let entity = ActorEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.profilePath = profilePath
        entity.knownForDepartment = Department.acting.rawValue
        entity.popularity = popularity ?? 0
        entity.gender  = Int16(gender ?? 0)
        entity.name = name
        entity.homepage = homepage
        entity.birthday = birthday
        entity.biography = biography
        return entity
    }
}


