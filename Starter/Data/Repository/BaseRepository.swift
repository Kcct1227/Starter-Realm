//
//  BaseRepository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import RealmSwift

class BaseRepository: NSObject {
    //let db = TempDatabase.shared
    let coreData = CoreDataStack.shared
    let realmDB = try! Realm()
    
    override init(){
        super.init()
        print("Default Realm is at \(realmDB.configuration.fileURL?.absoluteString ?? "undefined")")
    }
}


enum MDBError : Error {
    case withMessage(String)
}
