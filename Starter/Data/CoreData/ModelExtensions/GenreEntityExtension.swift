//
//  GenreEntityExtension.swift
//  Starter
//
//  Created by KC on 23/03/2022.
//

import Foundation

extension GenreEntity{
    static func toMovieGenre(entity: GenreEntity) -> MovieGenre{
        MovieGenre(id: Int(entity.id ?? "0") ?? 0 , name: entity.name ?? "")
    }
}
