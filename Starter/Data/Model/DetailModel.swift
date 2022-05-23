//
//  RxActorModel.swift
//  Starter
//
//  Created by KC on 10/05/2022.
//

import Foundation
import RxSwift
import RxAlamofire
import RxCocoa
import CoreData

protocol DetailModel {
    func deinitActorResultController()
    func getActorMovieContentObservable() -> Observable<[MovieResult]>
    func getActorDetailObservable() -> Observable<ActorDetailResponse>
    func initActorFetchResultController(id: Int)
    
    func deinitSeriesResultController()
    func getSimilarSeriesObservable() -> Observable<[MovieResult]>
    func getSeriesCastObservable() -> Observable<[MovieCast]>
    func getSeriesDetailObservable() -> Observable<MovieDetailResponse>
    func initSeriesFetchResultController(id: Int)
    
    func initFetchResultController(id: Int)
    func deinitMovieResultController()
    func getSimilarMoviesObservable() -> Observable<[MovieResult]>
    func getMovieCastObservable() -> Observable<[MovieCast]>
    func getMovieDetailObservable() -> Observable<MovieDetailResponse>
    
    func saveActorDetailObservable(id: Int) ->  Observable<ActorDetailResponse>
    func saveMovieDetailObservable(id: Int) ->  Observable<MovieDetailResponse>
    
    func saveMovieDetail(id: Int)
    func saveActorDetail(id: Int)
    func saveSeriesDetail(id: Int)
    
}

class DetailModelImpl: BaseModel, DetailModel {
   
    

    let disposeBag = DisposeBag()
    
    static let shared : DetailModel = DetailModelImpl()
    
    private override init() { }
    
    private let actorDetailRepository : ActorDetailRepository = ActorDetailRepositoryImpl.shared
    private let movieDetailRespository : MovieDetailRepository = MovieDetailRepositoryImpl.shared
    private let seriesDetailRepsitory : SeriesDetailRepository = SeriesDetailRepositoryImpl.shared
    
    private let movieRespository : MovieRepository = MovieRespositoryImpl.shared
    private let actorRepository : ActorRepository = ActorRepositoryImpl.shared

    func deinitActorResultController() {
        actorDetailRepository.deinitActorResultController()
    }
    
    func getActorMovieContentObservable() -> Observable<[MovieResult]> {
        actorDetailRepository.getActorMovieContentObservable()
    }
    
    func getActorDetailObservable() -> Observable<ActorDetailResponse> {
        actorDetailRepository.getActorDetailObservable()
    }
    
    func initActorFetchResultController(id: Int) {
        actorDetailRepository.initActorFetchResultController(id: id)
    }

    
    func deinitSeriesResultController() {
        seriesDetailRepsitory.deinitSeriesResultController()
    }
    
    func getSimilarSeriesObservable() -> Observable<[MovieResult]> {
        seriesDetailRepsitory.getSimilarSeriesObservable()
    }
    
    func getSeriesCastObservable() -> Observable<[MovieCast]> {
        seriesDetailRepsitory.getSeriesCastObservable()
    }
    
    func getSeriesDetailObservable() -> Observable<MovieDetailResponse> {
        seriesDetailRepsitory.getSeriesDetailObservable()
    }
    
    func initSeriesFetchResultController(id: Int) {
        seriesDetailRepsitory.initSeriesFetchResultController(id: id)
    }
    

    
    func getSimilarMoviesObservable() -> Observable<[MovieResult]>  {
        movieDetailRespository.getSimilarMoviesObservable()
    }
    
    func deinitMovieResultController() {
        movieDetailRespository.deinitMovieResultController()
    }
    
    func getMovieCastObservable() -> Observable<[MovieCast]>{
        movieDetailRespository.getMovieCastObservable()
    }

    
    func getMovieDetailObservable() -> Observable<MovieDetailResponse> {
        movieDetailRespository.getMovieDetailObservable()
    }
    
    func initFetchResultController(id: Int) {
        movieDetailRespository.initFetchResultController(id: id )
    }
    
    
    func saveActorDetailObservable(id: Int) ->  Observable<ActorDetailResponse>  {
        var result : ActorDetailResponse?
        
        return RxNetworkAgent.shared.getActorDetailById(id: id)
            .do(onNext: { data in
                result = data
                self.actorRepository.saveDetials(data: data)
                })
                .catchAndReturn(ActorDetailResponse.empty())
                    .flatMap{ _ ->  Observable<ActorDetailResponse> in
                        return Observable.create{ (observer) -> Disposable in
                            if result?.id != nil {
                                observer.onNext(result ?? ActorDetailResponse.empty())
                                observer.onCompleted()
                            }
                            else{
                                self.actorRepository.getDetails(id: id){
                                    observer.onNext($0 ?? ActorDetailResponse.empty())
                                    observer.onCompleted()
                                }

                            }
                return Disposables.create()
            }
        }

      
    }
    
    
    func saveMovieDetailObservable(id: Int) ->  Observable<MovieDetailResponse>  {
        var result : MovieDetailResponse?
        
        return RxNetworkAgent.shared.getMovieDetailById(id: id)
            .do(onNext: { data in
                result = data
                self.movieRespository.saveDetail(data: data)
                })
                .catchAndReturn(MovieDetailResponse.empty())
                    .flatMap{ _ ->  Observable<MovieDetailResponse> in
                        return Observable.create{ (observer) -> Disposable in
                            if result?.id != nil {
                                observer.onNext(result ?? MovieDetailResponse.empty())
                                observer.onCompleted()
                            }
                            else{
                                self.movieRespository.getDetail(id: id){
                                    observer.onNext($0 ?? MovieDetailResponse.empty())
                                    observer.onCompleted()
                                }

                            }
                return Disposables.create()
            }
        }

      
    }
    
    
    func saveActorDetail(id: Int) {
        RxNetworkAgent.shared.getActorDetailById(id: id)
            .subscribe(onNext : { data in

                self.actorRepository.saveDetials(data: data)
               
            }).disposed(by: disposeBag)

      
    }
    
    func saveMovieDetail(id: Int) {
        RxNetworkAgent.shared.getMovieDetailById(id: id)
            .subscribe(onNext : { data in
                self.movieRespository.saveDetail(data: data)
            }).disposed(by: disposeBag)
    }
    
    
    func saveSeriesDetail(id: Int) {
        RxNetworkAgent.shared.getSereisDetailById(id: id)
            .subscribe(onNext : { data in
                self.movieRespository.saveDetail(data: data.toMovieDetailResponse())
            }).disposed(by: disposeBag)

    }
    
    
        
}
    


