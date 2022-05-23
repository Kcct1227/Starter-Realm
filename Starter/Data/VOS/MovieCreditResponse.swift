//
//  MovieCreditResponse.swift
//  Starter
//
//  Created by KC on 15/03/2022.
//

import Foundation


// MARK: - MovieCreditResponse
struct MovieCreditResponse: Codable {
    let id: Int?
    let cast, crew: [MovieCast]?
    
    internal init(id: Int?, cast: [MovieCast]?, crew: [MovieCast]?) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }
}

// MARK: - Cast
struct MovieCast: Codable {
    
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: Department?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department: Department?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    init(adult: Bool?, gender: Int?, id: Int?, knownForDepartment: Department?, name: String?, originalName: String?, popularity: Double?, profilePath: String?, castID: Int?, character: String?, creditID: String?, order: Int?, department: Department?, job: String?) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.castID = castID
        self.character = character
        self.creditID = creditID
        self.order = order
        self.department = department
        self.job = job
    }
    
    func convertToActorInfoResponse()-> ActorInfoResponse{
        return ActorInfoResponse(adult: self.adult, gender: self.gender, id: self.id, knownFor: nil, knownForDepartment: self.knownForDepartment?.rawValue, name: self.name, popularity: self.popularity, profilePath: self.profilePath)
    }
    
    
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}
