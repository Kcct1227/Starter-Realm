//
//  ProductionCountryExtension.swift
//  Starter
//
//  Created by KC on 24/03/2022.
//

import Foundation
extension ProductionCountryEntity{
    static func toProductionCountry(entity: ProductionCountryEntity) -> ProductionCountry{
        ProductionCountry(iso3166_1: entity.iso3166_1, name: entity.name)
    }
}
