//
//  MovieDetailEntityExtension.swift
//  Starter
//
//  Created by KC on 23/03/2022.
//

import Foundation
extension ProductionCompanyEntity{
    static func toProductionCompay(entity: ProductionCompanyEntity) -> ProductionCompany{
        ProductionCompany(id: Int(entity.id), logoPath: entity.logoPath, name: entity.name, originCountry: entity.originCountry)
    }
}
