//
//  Models.swift
//  NetworkTesting
//
//  Created by KC on 10/03/2022.
//

import Foundation

struct LoginSuccess: Codable{
    
    let success : Bool?
    let expires_at: String?
    let request_token: String?

}

struct RequestTokenResponse: Codable{
    let success : Bool?
    let expiresAt : String?
    let requestToken : String?
    
    enum CodingKeys : String, CodingKey{
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct LoginFailed: Codable{
    
    let success : Bool?
    let statusCode : Int?
    let statusMessage : String?
    
    enum CodingKeys: String, CodingKey{
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
//    let success : Bool?
//    let status_code : Int?
//    let status_message : String?
}

struct LoginRequest: Codable{
    let username: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey{
        case username
        case password
        case requestToken = "request_token"
    }
}

public struct MovieGenreList: Codable{
    let genres : [MovieGenre]
}

public struct MovieGenre : Codable{
    public let id: Int
    public let name: String
    
    init(id:Int, name:String){
        self.id = id
        self.name = name
    }
    
    enum CodingKeys : String, CodingKey{
        case id
        case name = "name"
    }
    
    func converToGenreVO() -> GenreVO{
        let vo = GenreVO(id: id, name: name, isSelected: false)
        
        return vo
    }
}

var movieGenres = [MovieGenre]()

public struct ActorCombinedList: Codable {
   
    
    let cast, crew: [MovieResult]?
    let id: Int?
    
    init(cast: [MovieResult]?, crew: [MovieResult]?, id: Int?) {
        self.cast = cast
        self.crew = crew
        self.id = id
    }
    
}

struct BelongToType: Codable{
    let name: String?
    let movies: [MovieResult]?
}
