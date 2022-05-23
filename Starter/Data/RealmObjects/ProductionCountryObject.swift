//
//  ProductionCountryObject.swift
//  Starter
//
//  Created by KC on 30/03/2022.
//

import Foundation
import RealmSwift

class ProductionCountryObject : Object {
    @Persisted(primaryKey: true)
    var iso3166_1 : String?
    @Persisted
    var name: String?
    
    func toProductionCountry()-> ProductionCountry{
        return ProductionCountry(iso3166_1: iso3166_1, name: name)
    }
}
