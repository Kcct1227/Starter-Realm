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
}

class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    static let shared : RxMovieModel = RxMovieModelImpl()

    private override init() { }
    
    private let movieRepository : MovieRepository = MovieRespositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRespositoryImpl.shared
    private let genreRepository : GenreRepository = GenreRepositoryImpl.shared
    
    let disposeBag = DisposeBag()
    
    func getTopRatedMovieList(page : Int) -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getTopRatedMovieList(page: page)
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .topRatedMovies, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRespositoryImpl.shared.getMoviesOrSeries(type: .topRatedMovies)
    }
    
    func getPopularMovieList() -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getPopularMovieList(page: 1)
            .subscribe(onNext: { data in
            
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposeBag)
        
        return ContentTypeRespositoryImpl.shared.getMoviesOrSeries(type: .popularMovies)
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getUpcomingMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .upcomingMovies, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRespositoryImpl.shared.getMoviesOrSeries(type: .upcomingMovies)
    }
    
    func getGenreList() -> Observable<[MovieGenre]>  {
        RxNetworkAgent.shared.getGenreList()
            .subscribe(onNext: { data in
                self.genreRepository.save(data: data)
            })
            .disposed(by: disposeBag)
            
        return GenreRepositoryImpl.shared.get()
    }
    
    func getPopularSeriesList() -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getPopularSeriesList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .upcomingSeries, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRespositoryImpl.shared.getMoviesOrSeries(type: .upcomingSeries)
    }
    
}
