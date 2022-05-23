//
//  ProductionCompanyExtension.swift
//  Starter
//
//  Created by KC on 01/04/2022.
//

import Foundation
import RealmSwift

extension ProductionCompany{
    static func toProductionCompanyObject(data: ProductionCompany)->ProductionCompanyObject{
        let object = ProductionCompanyObject()
        object.id = data.id
        object.logoPath = data.logoPath
        object.name = data.name
        object.originCountry = data.originCountry
        return object
    }
}

extension ProductionCountry{
    static func toProductionCountryObject(data: ProductionCountry) -> ProductionCountryObject{
        let object = ProductionCountryObject()
        object.iso3166_1 = data.iso3166_1
        object.name = data.name
        return object
    }
}
