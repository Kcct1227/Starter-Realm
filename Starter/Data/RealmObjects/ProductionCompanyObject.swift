//
//  ProductionCompanyObject.swift
//  Starter
//
//  Created by KC on 30/03/2022.
//

import Foundation
import RealmSwift

class ProductionCompanyObject : Object{
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var logoPath : String?
    @Persisted
    var name : String?
    @Persisted
    var originCountry: String?
    
    func toProductionCompany()-> ProductionCompany{
        return ProductionCompany(id: id, logoPath: logoPath, name: name, originCountry: originCountry)
    }
}
