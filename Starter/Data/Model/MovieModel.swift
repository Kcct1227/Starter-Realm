//
//  MovieModel.swift
//  Starter
//
//  Created by KC on 18/03/2022.
//

import Foundation
import RxSwift

protocol MovieModel{
    
    var totalTopRatedPage : Int { get set }
    
    func getMovieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getMovieTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getUpComingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getMovieCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getSimilarMovieById(id: Int, completion : @escaping (MDBResult<[MovieResult]>) -> Void)
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getGenreList(completion : @escaping (MDBResult<[MovieGenre]>) -> Void)
    func getPopularMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func testing()
    
    func getUpComingMovieList() -> Observable<[MovieResult]>
}

class MovieModelImpl: BaseModel, MovieModel {
    var totalTopRatedPage: Int = 1

    static let shared = MovieModelImpl()
    private let genreRepository : GenreRepository = GenreRepositoryImpl.shared
    private let movieRespository : MovieRepository = MovieRespositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRespositoryImpl.shared
    
    private override init() {}
    
    func testing(){
        contentTypeRepository.testing()
    }
    
    
    func getMovieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void){
        networkAgent.getMovieDetailById(id: id){ (result) in
            switch result {
            case .success(let data) :
                self.movieRespository.saveDetail( data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRespository.getDetail(id: id){ (item) in
                if let item = item{
                    
                    completion(.success(item))
                }
                else{
                    completion(.failure("Failed to get detail with id \(id)"))
                }
                
            }
        }
    }

    func getMovieTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void){
        networkAgent.getMovieTrailerVideo(id: id, completion: completion)
    }
    
    func getMovieCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void){
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
            
    }
    
    func getSimilarMovieById(id: Int, completion : @escaping (MDBResult<[MovieResult]>) -> Void){
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
            
    }
    
    func getTopRatedMovieList(page: Int,  completion: @escaping (MDBResult<[MovieResult]>) -> Void){
        let contentType : MovieSerieGroupType = .topRatedMovies
        networkAgent.getTopRatedMovieList(page: page){ (result) in
            switch result {
            case .success(let data) :
                self.movieRespository.saveList(type: contentType, data: data)
                self.totalTopRatedPage = data.totalPages ?? 1

            case .failure(let error):
                
                print("\(#function) \(error)")
            }
            self.contentTypeRepository.getMoviesOrSeries( type: contentType){
                completion(.success($0))
            }
        
            
        }
    }
    
    func getUpComingMovieList() -> Observable<[MovieResult]> {
        let contentType : MovieSerieGroupType = .upcomingMovies

        return RxNetworkAgent.shared.getUpcomingMovieList()
                .do(onNext: { data in
                    self.movieRespository.saveList(type: contentType, data: data)
                })
                    //.catchAndReturn([MovieResult]())
                    .flatMap{ _ ->  Observable<[MovieResult]> in
                        return Observable.create{ (observer) -> Disposable in
                            self.contentTypeRepository.getMoviesOrSeries(type: contentType){
                                observer.onNext($0)
                                observer.onCompleted()
                            }
                return Disposables.create()
            }
        }
    }
    
    func getUpComingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void){
        let contentType : MovieSerieGroupType = .upcomingMovies
        networkAgent.getUpComingMovieList(){ (result) in
            switch result {
            case .success(let data) :
                self.movieRespository.saveList(type: contentType, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            
            self.contentTypeRepository.getMoviesOrSeries(type: contentType){
                completion(.success($0))
            }
            
            //self.contentTypeRepository.testing()

        }
    }
    
    func getGenreList(completion : @escaping (MDBResult<[MovieGenre]>) -> Void){
        // [1] - fetch from Network
        networkAgent.getGenreList{ (result) in
            switch result{
            case .success(let data) :
                
                // [2] - Save to Database
                self.genreRepository.save(data: data)
                
            case .failure(let error):
                print("\(#function) \(error)" )
            }
            
            // [3] - Fetch inserted data from Database
            self.genreRepository.get{ completion(.success($0.genres))}
            
        }
    }
    
    func getPopularMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void){
        let contentType : MovieSerieGroupType = .popularMovies
        networkAgent.getPopularMovieList(page: page){ (result) in
            switch result {
            case .success(let data) :
                self.movieRespository.saveList(type: contentType, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: contentType){
                completion(.success($0))
            }
        }
    }
}
