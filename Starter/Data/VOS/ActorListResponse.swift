//
//  ActorListResponse.swift
//  Starter
//
//  Created by KC on 11/03/2022.
//

import Foundation
import CoreData

public struct ActorListResponse: Codable{
    let dates: Dates?
    let page: Int?
    let results: [ActorInfoResponse]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    init(dates: Dates?, page: Int?, results: [ActorInfoResponse]?, totalPages: Int?, totalResults: Int?){
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    static func empty()-> ActorListResponse{
        return ActorListResponse(dates: nil, page: nil, results: nil, totalPages: nil, totalResults: nil)
    }
}

public struct ActorInfoResponse : Codable{
    let adult : Bool?
    let gender: Int?
    let id: Int?
    let knownFor : [MovieResult]?
    let knownForDepartment : String?
    let name : String?
    let popularity : Double?
    let profilePath : String?
    
    enum CodingKeys : String, CodingKey{
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name
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
        entity.homepage = ""
        entity.birthday = ""
        entity.biography = ""
        //entity.addToCredits(groupTye)
        return entity
    }
    
   
    
}
