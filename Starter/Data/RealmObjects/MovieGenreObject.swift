//
//  MovieGenreObject.swift
//  Starter
//
//  Created by KC on 30/03/2022.
//

import Foundation
import RealmSwift

class MovieGenreObject : Object {
    @Persisted (primaryKey: true)
    var id: Int
    @Persisted
    var name: String
    
    func toMovieGenre()-> MovieGenre{
        return MovieGenre(id: id, name: name)
    }
}
