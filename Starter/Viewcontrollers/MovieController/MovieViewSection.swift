//
//  MovieViewSectionItem.swift
//  Starter
//
//  Created by KC on 09/05/2022.
//

import Foundation
import Differentiator

enum SectionItem{
    case upcomingMoviesSection(items: [MovieResult])
    case popularMoviesSection(items: [MovieResult])
    case popularSeriesSection(items: [MovieResult])
    case movieShowTimeSection
    case movieGenreSection(genres: [MovieGenre], movies: [MovieResult])
    case showcaseMoviesSection(items:[MovieResult])
    case bestActorSection(items: [ActorInfoResponse])
}

enum HomeMovieSectionModel: SectionModelType{
    init(original: HomeMovieSectionModel, items: [SectionItem]) {
        switch original {
        case .movieResult(let results):
            self = .movieResult(items: results)
        case .actorResult(let results):
            self = .actorResult(items: results)
        case .genreResult(let results):
            self = .genreResult(items: results)
        case .others(let results):
            self = .others(items: results)
        }
    }
    
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .movieResult(let items):
            return items
        case .actorResult(let items):
            return items
        case .genreResult(let items):
            return items
        case .others(let items):
            return items
        }
    }

    case movieResult(items: [SectionItem])
    case actorResult(items: [SectionItem])
    case genreResult(items: [SectionItem])
    case others(items: [SectionItem])
}
