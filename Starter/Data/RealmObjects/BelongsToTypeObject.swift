//
//  BelongsToTypeObject.swift
//  Starter
//
//  Created by KC on 31/03/2022.
//

import Foundation
import RealmSwift

class BelongsToTypeObject : Object {

    
    @Persisted(primaryKey: true)
    var name: String
    
    @Persisted(originProperty: "belongsToType")
    var movies: LinkingObjects<MovieResultObject>
    
//    @Persisted
//    var movieList : List<MovieResultObject>
//
//    func toBelongToType ()-> BelongToType {
//        let movies:[MovieResult] = movieList.map{
//            $0.toMovieResult()
//        }
//
//        return BelongToType(name: name, movies: movies)
//    }
    
    
}
