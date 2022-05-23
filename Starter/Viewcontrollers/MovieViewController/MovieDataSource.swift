//
//  MovieDataSource.swift
//  Starter
//
//  Created by KC on 10/05/2022.
//

import Foundation
import RxDataSources
import UIKit

extension MovieViewController{
    func initDataSource() -> RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>{
        return RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>.init{ (dataSource, tableView, indexPath, items) -> UITableViewCell in
            switch items {
            case .popularMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.delegate = self
                cell.contentType = ContentType.MovieType.rawValue
                cell.labelTitle.text = "popular movies".uppercased()
                cell.data = items
                return cell
            case .upcomingMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                cell.delegate = self
                cell.contentType = ContentType.MovieType.rawValue
                cell.data = items
                return cell
                
            case .bestActorSection(let items):
                let cell =  tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
                cell.delegate = self
                cell.data = items
                cell.contentType = ContentType.ActorType.rawValue
                cell.moreActorDelegate = self
                return cell
            case .popularSeriesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.delegate = self
                cell.contentType = ContentType.SerieType.rawValue
                cell.labelTitle.text = "popular series".uppercased()
                cell.data = items
                return cell
            case .showcaseMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
                cell.delegate = self
                cell.data = items
                cell.contentType = ContentType.MovieType.rawValue
                cell.moreShowCaseDelegate = self
                return cell
            case .movieGenreSection(let genres,let items):
                let cell = tableView.dequeueCell(identifier: GenereTableViewCell.identifier, indexPath: indexPath) as GenereTableViewCell
                cell.delegate = self
                            
                cell.allMoviesAndSeries = items
                let resultData : [GenreVO]? = genres.map{ movieGenre -> GenreVO in
                    return movieGenre.converToGenreVO()
                }
                resultData?.first?.isSelected = true
                cell.genreList = resultData
                cell.contentType = ContentType.MovieType.rawValue
                
                return cell
            case .movieShowTimeSection:
                let cell = tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
                return cell
           
            }
        }
    }
}
