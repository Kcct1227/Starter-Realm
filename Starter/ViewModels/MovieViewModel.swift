//
//  MovieViewModel.swift
//  Starter
//
//  Created by KC on 19/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

class MovieViewModel{
    
    // observables
    let homeItemList                        = BehaviorRelay<[HomeMovieSectionModel]>(value:[])
    private var observablePopularMovies     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableTopRatedMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableUpcomingMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableActorList         = BehaviorRelay<[ActorInfoResponse]>(value:[])
    private var observablePopularSeries     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableGenreList         = BehaviorRelay<[MovieGenre]>(value:[])
    
    // Models
    private let rxmovieModel        = RxMovieModelImpl.shared
    private let actorModel          = ActorModelImpl.shared

    
    private let disposeBag = DisposeBag()
    
    init(){
        initObservers()
    }
    
    private func initObservers() {
        Observable.combineLatest(
            observableGenreList,
            observableTopRatedMovies,
            observablePopularMovies,
            observablePopularSeries,
            observableUpcomingMovies,
            observableActorList
        )
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .subscribe { (
            genreList,
            topRatedMovies,
            popularMovies,
            popularSeries,
            upcomingMovies,
            actorList) in
            var items = [HomeMovieSectionModel]()
            if !upcomingMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.upcomingMoviesSection(items: upcomingMovies)]))
            }
            
            if !popularMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularMoviesSection(items: popularMovies)]))
            }
            
            if !popularSeries.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularSeriesSection(items: popularSeries)]))
            }
            
            items.append(HomeMovieSectionModel.others(items: [.movieShowTimeSection]))
            
            if !genreList.isEmpty {
                items.append(HomeMovieSectionModel.genreResult(items: [.movieGenreSection(genres: genreList, movies: upcomingMovies + popularMovies + popularSeries)]))
            }
            
            if !topRatedMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.showcaseMoviesSection(items: topRatedMovies)]))
            }
            
            if !actorList.isEmpty {
                items.append(HomeMovieSectionModel.actorResult(items: [.bestActorSection(items: actorList)]))
            }
            //return .just(items)
            self.homeItemList.accept(items)
        }.disposed(by: disposeBag)
    }
    
    func fetchAllData(){
        getPopularMovieList()
        getPopularSeriesList()
        getTopRatedMovieList(page: 1)
        getUpcomingMovieList()
        getPopularPeople(page: 1)
        getGenreList()
    }
    
    private func getPopularMovieList(){
        rxmovieModel.getPopularMovieList()
            .subscribe(onNext: { self.observablePopularMovies.accept($0) })
            .disposed(by: disposeBag)
    }
    
    private func getPopularSeriesList(){
        rxmovieModel.getPopularSeriesList()
            .subscribe(onNext: { items in
                self.observablePopularSeries.accept(items)
            })
            .disposed(by: disposeBag)
    }
    
    private func getTopRatedMovieList(page: Int){
        rxmovieModel.getTopRatedMovieList(page: 1)
            .subscribe(onNext: { self.observableTopRatedMovies.accept($0) })
            .disposed(by: disposeBag)
    }
    
    private func getUpcomingMovieList(){
        rxmovieModel.getUpcomingMovieList()
            .subscribe(onNext: { self.observableUpcomingMovies.accept($0) })
            .disposed(by: disposeBag)

    }
    
    private func getPopularPeople(page: Int){
        actorModel.getPopularPeople(page: 1)
            .subscribe(onNext: { self.observableActorList.accept($0) })
            .disposed(by: disposeBag)

    }
    
    private func getGenreList(){
        rxmovieModel.getGenreList()
            .subscribe(onNext: { self.observableGenreList.accept($0) })
            .disposed(by: disposeBag)
    }
}
