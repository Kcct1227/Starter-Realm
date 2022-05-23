//
//  RxNetworkAgent.swift
//  Starter
//
//  Created by KC on 04/05/2022.
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
    func getPopularPeople(page : Int) -> Observable<ActorInfoResponse>
    func getPopularSeriesList() -> Observable<MovieListResult>
}


class RxNetworkAgent : BaseNetworkAgent, RxNetworkAgentProtocol{
   

    static let shared = RxNetworkAgent()
    
    private override init(){
        
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
    
    func getPopularPeople(page: Int) -> Observable<ActorInfoResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.popularPeople(page))
            .flatMap { item -> Observable<ActorInfoResponse> in
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
