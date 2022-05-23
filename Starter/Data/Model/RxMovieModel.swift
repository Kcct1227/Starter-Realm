//
//  RxMoiveModel.swift
//  Starter
//
//  Created by KC on 09/05/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

protocol RxMovieModel {
    func getTopRatedMovieList(page : Int) -> Observable<[MovieResult]>
    func getPopularMovieList() -> Observable<[MovieResult]>
    func getUpcomingMovieList() -> Observable<[MovieResult]>
    func getGenreList() -> Observable<[MovieGenre]>
    func getPopularSeriesList() -> Observable<[MovieResult]>
    func getMovieCreditByid(id: Int) -> Observable<[MovieCast]>
    func getSeriesCreditById(id: Int) -> Observable<[MovieCast]>
    func getActorCombinedListById(id: Int) -> Observable<[MovieResult]>
    func getSimilarMovieById(id: Int) -> Observable<[MovieResult]>
    func getSimilarSeriesById(id: Int) -> Observable<[MovieResult]>
}

class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    static let shared : RxMovieModel = RxMovieModelImpl()

    private override init() { }
    
    private let movieRespository : MovieRepository = MovieRespositoryImpl.shared
    private let actorRepository: ActorRepository = ActorRepositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRespositoryImpl.shared
    private let genreRepository : GenreRepository = GenreRepositoryImpl.shared
    
    let disposeBag = DisposeBag()
    
    func getTopRatedMovieList(page : Int) -> Observable<[MovieResult]>  {

        let contentType : MovieSerieGroupType = .topRatedMovies
        var result = [MovieResult]()
        return RxNetworkAgent.shared.getTopRatedMovieList(page: page)
                .do(onNext: { data in
                    self.movieRespository.saveList(type: contentType, data: data)
                    result = data.results ?? [MovieResult]()
                })
                    .catchAndReturn(MovieListResult.empty())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            if result.count == 0 {
                                self.contentTypeRepository.getMoviesOrSeries(type: contentType){
                                    observer.onNext($0)
                                    observer.onCompleted()
                                }
                            }
                            else{
                                observer.onNext(result)
                                observer.onCompleted()
                            }
                            
                return Disposables.create()
            }
        }
    }
    
    func getPopularMovieList() -> Observable<[MovieResult]>  {

        let contentType : MovieSerieGroupType = .popularMovies
        var result = [MovieResult]()
        return RxNetworkAgent.shared.getPopularMovieList(page: 1)
                .do(onNext: { data in
                    self.movieRespository.saveList(type: contentType, data: data)
                    result = data.results ?? [MovieResult]()
                })
                    .catchAndReturn(MovieListResult.empty())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            if result.count == 0 {
                                self.contentTypeRepository.getMoviesOrSeries(type: contentType){
                                    observer.onNext($0)
                                    observer.onCompleted()
                                }
                            }
                            else{
                                observer.onNext(result)
                                observer.onCompleted()
                            }
                            
                return Disposables.create()
            }
        }
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]>  {

        let contentType : MovieSerieGroupType = .upcomingMovies
        var result = [MovieResult]()
        return RxNetworkAgent.shared.getUpcomingMovieList()
                .do(onNext: { data in
                    self.movieRespository.saveList(type: contentType, data: data)
                    result = data.results ?? [MovieResult]()
                })
                    .catchAndReturn(MovieListResult.empty())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            if result.count == 0 {
                                self.contentTypeRepository.getMoviesOrSeries(type: contentType){
                                    observer.onNext($0)
                                    observer.onCompleted()
                                }
                            }
                            else{
                                observer.onNext(result)
                                observer.onCompleted()
                            }
                            
                return Disposables.create()
            }
        }
    }
    
    func getActorCombinedListById(id: Int) -> Observable<[MovieResult]>{
        return RxNetworkAgent.shared.getActorCombinedList(id: id)
            .do(onNext: { data in
                self.actorRepository.saveActorCombinedList(id: data.id ?? 0, data: data.cast ?? [MovieResult]())
                })
                .catchAndReturn(ActorCombinedList.empty())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            self.actorRepository.getActorCombinedList(id: id){
                                observer.onNext($0)
                                observer.onCompleted()
                            }
                return Disposables.create()
            }
        }
    }
    
    func getSimilarSeriesById(id: Int) -> Observable<[MovieResult]>{
        return RxNetworkAgent.shared.getSimilarSeriesById(id: id)
            .do(onNext: { data in
                self.movieRespository.saveSimilarContent(id: id, data: data.results ?? [MovieResult]())
            })
                .catchAndReturn(MovieListResult.empty())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            self.movieRespository.getSimilarContent(id: id){
                                observer.onNext($0)
                                observer.onCompleted()
                            }
                return Disposables.create()
            }
        }
    }
    
    func getSimilarMovieById(id: Int) -> Observable<[MovieResult]>{
        return RxNetworkAgent.shared.getSimilarMovieById(id: id)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { data in
                self.movieRespository.saveSimilarContent(id: id, data: data.results ?? [MovieResult]())
            })
                .catchAndReturn(MovieListResult.empty())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            self.movieRespository.getSimilarContent(id: id){
                                observer.onNext($0)
                                observer.onCompleted()
                            }
                return Disposables.create()
            }
        }
    }
        
        
        /*
         networkAgent.getSimilarMovieById(id: id){ (result) in
             switch result {
             case .success(let data) :
                 self.movieRespository.saveSimilarContent(id: id, data: data.results ?? [MovieResult]())
             case .failure(let error):
                 print("\(#function) \(error)")
             }
             
             self.movieRespository.getSimilarContent(id: id){
                 completion(.success($0))
             }
         }
         */
    
    
    func getMovieCreditByid(id: Int) -> Observable<[MovieCast]>{
        return RxNetworkAgent.shared.getMovieCreditByid(id: id)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { data in
                self.movieRespository.saveCasts(id: id, data: data.cast ?? [MovieCast]())
                })
                .catchAndReturn(MovieCreditResponse.isEmpty())
                    .flatMap{ _ ->  Observable<[MovieCast]> in
                        return Observable.create{ (observer) -> Disposable in
                            self.movieRespository.getCasts(id: id){
                                observer.onNext($0)
                                observer.onCompleted()
                            }
                return Disposables.create()
            }
        }
                        
    }
    
    func getSeriesCreditById(id: Int) -> Observable<[MovieCast]>{
        return RxNetworkAgent.shared.getSeriesCreditByid(id: id)
            .do(onNext: { data in
                self.movieRespository.saveCasts(id: id, data: data.cast ?? [MovieCast]())
                })
                .catchAndReturn(MovieCreditResponse.isEmpty())
                    .flatMap{ _ ->  Observable<[MovieCast]> in
                        return Observable.create{ (observer) -> Disposable in
                            self.movieRespository.getCasts(id: id){
                                observer.onNext($0)
                                observer.onCompleted()
                            }
                return Disposables.create()
            }
        }
                        
    }
    /*
     networkAgent.getMovieCreditByid(id: id){ (result) in
         switch result {
         case .success(let data) :
             self.movieRespository.saveCasts(id: id, data: data.cast ?? [MovieCast]())
         case .failure(let error):
             print("\(#function) \(error)")
         }
         
         self.movieRespository.getCasts(id: id){
             completion(.success(MovieCreditResponse(id: id, cast: $0, crew: $0)))
         }
         
     }
     */
    
    func getGenreList() -> Observable<[MovieGenre]>  {
//        RxNetworkAgent.shared.getGenreList()
//            .subscribe(onNext: { data in
//                self.genreRepository.save(data: data)
//            })
//            .disposed(by: disposeBag)
//
//        return GenreRepositoryImpl.shared.get()
        

        return RxNetworkAgent.shared.getGenreList()
                .do(onNext: { data in
                    self.genreRepository.save(data: data)
                })
                    .catchAndReturn(MovieGenreList.empty())
                    .flatMap{ _ ->  Observable<[MovieGenre]> in
                        return Observable.create{ (observer) -> Disposable in
                            GenreRepositoryImpl.shared.get(){
                                observer.onNext($0.genres)
                                observer.onCompleted()
                            }
                return Disposables.create()
            }
        }
    }
    
    func getPopularSeriesList() -> Observable<[MovieResult]>  {
        let contentType : MovieSerieGroupType = .popularSeries
        var result = [MovieResult]()
        return RxNetworkAgent.shared.getPopularSeriesList()
                .do(onNext: { data in
                    self.movieRespository.saveList(type: contentType, data: data)
                    result = data.results ?? [MovieResult]()
                })
                    .catchAndReturn(MovieListResult.empty())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            if result.count == 0 {
                                self.contentTypeRepository.getMoviesOrSeries(type: contentType){
                                    observer.onNext($0)
                                    observer.onCompleted()
                                }
                            }
                            else{
                                observer.onNext(result)
                                observer.onCompleted()
                            }
                            
                return Disposables.create()
            }
        }
//        RxNetworkAgent.shared.getPopularSeriesList()
//            .subscribe(onNext: { data in
//                self.movieRepository.saveList(type: .upcomingSeries, data: data)
//            })
//            .disposed(by: disposeBag)
//
//        return ContentTypeRespositoryImpl.shared.getMoviesOrSeries(type: .upcomingSeries)
    }
    
}
