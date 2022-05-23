//
//  MovieDetailsViewModelType.swift
//  Starter
//
//  Created by KC on 20/05/2022.
//

import Foundation
import Combine
import RxSwift

protocol MovieDetailViewModelType{
    var viewState: PassthroughSubject<ArtistDeatilViewState, Never> { get }
    var movieID : Int { get }
    var type: String { get }
    var isWatched: Bool { get }
    var movieCasts : BehaviorSubject<[MovieCast]> { get }
    var similarMovies : BehaviorSubject<[MovieResult]> { get }
    var movieTrailers : [MovieTrailer] { get }
    
    func setupData()
    func fetchDetails()
    func toggleWatched()
    func deinitFetchController()
    
}
