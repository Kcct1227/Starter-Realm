//
//  RxNetworkAgent.swift
//  Starter
//
//  Created by KC on 10/05/2022.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

protocol RxNetworkAgentProtocol  {
    func searchMovies(query: String, page: Int) -> Observable<MovieListResult>
    
    func getPopularMovieList(page: Int) -> Observable<MovieListResult>
    func getTopRatedMovieList(page : Int) -> Observable<MovieListResult>
    func getUpcomingMovieList() -> Observable<MovieListResult>
    func getGenreList() -> Observable<MovieGenreList>
    func getPopularPeople(page : Int) -> Observable<ActorListResponse>
    func getPopularSeriesList() -> Observable<MovieListResult>
    
    func getMovieDetailById(id : Int) -> Observable<MovieDetailResponse>
    func getMovieTrailerVideo(id: Int) -> Observable<MovieTrailerResponse>
    func getMovieCreditByid(id: Int) -> Observable<MovieCreditResponse>
    func getSimilarMovieById(id: Int) -> Observable<MovieListResult>
    
    func getSereisDetailById(id : Int) -> Observable<SeriesDetailResponse>
    func getSereisTrailerVideo(id: Int) -> Observable<MovieTrailerResponse>
    func getSeriesCreditByid(id: Int) -> Observable<MovieCreditResponse>
    func getSimilarSeriesById(id: Int) -> Observable<MovieListResult>
    
    func getActorCombinedList(id: Int)-> Observable<ActorCombinedList>
    func getActorDetailById(id:Int) -> Observable<ActorDetailResponse>
}


class RxNetworkAgent : BaseNetworkAgent, RxNetworkAgentProtocol{
    
    static let shared = RxNetworkAgent()
    
    private override init(){
        
    }
    
  
    
//    func getActorCombinedList(id: Int) -> Observable<ActorCombinedList> {
//        RxAlamofire.requestDecodable(MDBEndpoint.actorTVCredits(id))
//            .flatMap{ item -> Observable<ActorCombinedList> in
//                return Observable.just(item.1)
//            }
//    }
//
    
    func getSimilarSeriesById(id: Int) -> Observable<MovieListResult> {
        RxAlamofire.requestDecodable(MDBEndpoint.similarSeries(id))
            .flatMap{ item -> Observable<MovieListResult> in
                return Observable.just(item.1)
            }
    }
   
    
    func getSeriesCreditByid(id: Int) -> Observable<MovieCreditResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.seriesActors(id))
            .flatMap{ item -> Observable<MovieCreditResponse> in
                return Observable.just(item.1)
            }
    }
    
    
    func getSereisTrailerVideo(id: Int) -> Observable<MovieTrailerResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.trailerSeriesVideo(id))
            .flatMap{ item -> Observable<MovieTrailerResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getSereisDetailById(id: Int) -> Observable<SeriesDetailResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.seriesDetail(id))
            .flatMap{ item -> Observable<SeriesDetailResponse> in
                return Observable.just(item.1)
            }
        
    }
    
    func getSimilarMovieById(id: Int) -> Observable<MovieListResult> {
        RxAlamofire.requestDecodable(MDBEndpoint.similarMovie(id))
            .flatMap{ item -> Observable<MovieListResult> in
                return Observable.just(item.1)
            }
    }
    
 
    
    
    func getMovieTrailerVideo(id: Int) -> Observable<MovieTrailerResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.trailerVideo(id))
            .flatMap{ item -> Observable<MovieTrailerResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getMovieDetailById(id: Int) -> Observable<MovieDetailResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.movieDetails(id))
            .flatMap{ item -> Observable<MovieDetailResponse> in
                return Observable.just(item.1)
            }
        
    }
    
    func searchMovies(query: String, page: Int) -> Observable<MovieListResult> {
        RxAlamofire.requestDecodable(MDBEndpoint.searchMovie(page, query))
            .flatMap { item -> Observable<MovieListResult> in
                return Observable.just(item.1)
            }
    }
    
    func getTopRatedMovieList(page: Int) -> Observable<MovieListResult> {
        RxAlamofire.requestDecodable(MDBEndpoint.topRatedMovies(page))
            .flatMap { item -> Observable<MovieListResult> in
                return Observable.just(item.1)
            }
    }
    
    func getUpcomingMovieList() -> Observable<MovieListResult> {
        RxAlamofire.requestDecodable(MDBEndpoint.upComingMovie(1))
            .flatMap { item -> Observable<MovieListResult> in
                return Observable.just(item.1)
            }
    }
    
    func getGenreList() -> Observable<MovieGenreList> {
        RxAlamofire.requestDecodable(MDBEndpoint.movieGenres)
            .flatMap { item -> Observable<MovieGenreList> in
                return Observable.just(item.1)
            }
    }
    
    func getPopularPeople(page: Int) -> Observable<ActorListResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.popularPeople(page))
            .flatMap { item -> Observable<ActorListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getPopularSeriesList() -> Observable<MovieListResult> {
        RxAlamofire.requestDecodable(MDBEndpoint.popularTVSeries)
            .flatMap { item -> Observable<MovieListResult> in
                return Observable.just(item.1)
            }
    }
    
    func getPopularMovieList (page: Int) -> Observable<MovieListResult>{
        
        RxAlamofire.requestDecodable(MDBEndpoint.popularMovie(page))
            .flatMap{ item -> Observable<MovieListResult> in
                Observable.just(item.1)
                
            }
        
//        return Observable.create { (observer) -> Disposable in
//
//            AF.request(MDBEndpoint.popularMovie(page))
//                .responseDecodable(of: MovieListResult.self){ response in
//                    switch response.result{
//                    case .success(let data):
//                        observer.onNext(data)
//                        observer.onCompleted()
//                    case .failure(let error):
//                        observer.onError(error)
//                }
//            }
//
//            return Disposables.create()
//        }
    }
    
    func getMovieCreditByid(id: Int) -> Observable<MovieCreditResponse> {
//        return Observable.create { (observer) -> Disposable in
//
//            AF.request(MDBEndpoint.movieActors(id))
//                .responseDecodable(of: MovieCreditResponse.self){ response in
//                    switch response.result{
//                    case .success(let data):
//                        observer.onNext(data)
//                        observer.onCompleted()
//                    case .failure(let error):
//                        observer.onError(error)
//                }
//            }
//
//            return Disposables.create()
//        }
        RxAlamofire.requestDecodable(MDBEndpoint.movieActors(id))
            .flatMap{ item -> Observable<MovieCreditResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getActorDetailById(id: Int) -> Observable<ActorDetailResponse> {
        
        return Observable.create { (observer) -> Disposable in

            AF.request(MDBEndpoint.actorDetail(id))
                .responseDecodable(of: ActorDetailResponse.self){ response in
                    switch response.result{
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                }
            }

            return Disposables.create()
            
        }
        
//        RxAlamofire.requestDecodable(MDBEndpoint.actorDetail(id))
//            .flatMap{ item -> Observable<ActorDetailResponse> in
//                return Observable.just(item.1)
//            }
    }
    
    func getActorCombinedList(id: Int) -> Observable<ActorCombinedList> {
//        RxAlamofire.requestDecodable(MDBEndpoint.actorTVCredits(id))
//            .flatMap{ item -> Observable<ActorCombinedList> in
//                return Observable.just(item.1)
//            }
        return Observable.create { (observer) -> Disposable in

            AF.request(MDBEndpoint.actorTVCredits(id))
                .responseDecodable(of: ActorCombinedList.self){ response in
                    switch response.result{
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                }
            }

            return Disposables.create()
            
        }
                        
    }
    
    
   
    
}


class BaseNetworkAgent: NSObject {
    
    
    func handleError<T, E: MDBErrorModel>(
        _ response: DataResponse<T, AFError>,
        _ error: (AFError),
        _ errorBodyType : E.Type) -> String {
        
        
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        /// 2 - Extract debug info
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        
        /// 1 - Essential debug info
        print(
            """
             ======================
             URL
             -> \(sourcePath)
             
             Status
             -> \(respCode)
             
             Body
             -> \(respBody)

             Underlying Error
             -> \(error.underlyingError!)
             
             Error Description
             -> \(error.errorDescription!)
             ======================
            """
        )
        
        /// 4 - Client display
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
        
    }
    
}
