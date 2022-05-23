//
//  NetworkingAgent.swift
//  Starter
//
//  Created by KC on 10/03/2022.
//

import Foundation
import Alamofire

protocol MovieDBNetworkAgentProtocol {
    
    //MARK: - Movies
    func getMovieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getMovieTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getUpComingMovieList(completion: @escaping (MDBResult<MovieListResult>) -> Void)
    func getMovieCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getSimilarMovieById(id: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void)
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResult>) -> Void)
    func getGenreList(completion : @escaping (MDBResult<MovieGenreList>) -> Void)
    func getPopularMovieList(page: Int, completion: @escaping (MDBResult<MovieListResult>) -> Void)

    
    //MARK: Series
    func getSimilarSeriesById(id: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void)
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResult>) -> Void)
    func getSeriesDetailById(id : Int, completion : @escaping (MDBResult<SeriesDetailResponse>) -> Void)

    //MARK: Search
    func getSearchMovie(name: String, page: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void)
    
    //MARK: Actor
    func getActorDetailInfoById(id: Int, completion : @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getActorCombinedListById(id: Int, completion : @escaping (MDBResult<ActorCombinedList>) -> Void)
    func getPopularPeople(page:Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    func getSeriesCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getSeriesTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void)

}

struct MovieDBNetworkAgent : MovieDBNetworkAgentProtocol{

    static let shared = MovieDBNetworkAgent()
    
    private init(){}
    
    func getSearchMovie(name: String, page: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void){
        AF.request(MDBEndpoint.searchMovie(page, name))
            .responseDecodable(of: MovieListResult.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
            
        }
    }
    
    func getActorDetailInfoById(id: Int, completion : @escaping (MDBResult<ActorDetailResponse>) -> Void){
        AF.request(MDBEndpoint.actorDetail(id))
            .responseDecodable(of: ActorDetailResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
            }
            
        }
    }
    
    func getActorCombinedListById(id: Int, completion : @escaping (MDBResult<ActorCombinedList>) -> Void){
        AF.request(MDBEndpoint.actorTVCredits(id))
            .responseDecodable(of: ActorCombinedList.self) { response in
            switch response.result{
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                
            }
        }
    }
    
    
    func getMovieTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void){
        AF.request(MDBEndpoint.trailerVideo(id))
            .responseDecodable(of: MovieTrailerResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    func getSimilarMovieById(id: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void){
        AF.request(MDBEndpoint.similarMovie(id))
            .responseDecodable(of: MovieListResult.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            
            }
        }
    }
    
    func getSimilarSeriesById(id: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void){
        AF.request(MDBEndpoint.similarSeries(id))
            .responseDecodable(of: MovieListResult.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            
            }
        }
    }
    
    func getSeriesTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void){
        AF.request(MDBEndpoint.trailerSeriesVideo(id))
            .responseDecodable(of: MovieTrailerResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void){
        AF.request(MDBEndpoint.movieActors(id))
            .responseDecodable(of: MovieCreditResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
            
        }
    }
    
    func getSeriesCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void){
        AF.request(MDBEndpoint.seriesActors(id))
            .responseDecodable(of: MovieCreditResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
            
        }
    }
    
    func getSeriesDetailById(id : Int, completion : @escaping (MDBResult<SeriesDetailResponse>) -> Void) {
        AF.request(MDBEndpoint.seriesDetail(id))
            .responseDecodable(of: SeriesDetailResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        //let url = "\(AppConstants.BASEURL)/movie/\(id)?api_key=\(AppConstants.api_key)"
        AF.request(MDBEndpoint.movieDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularPeople(page:Int = 1, completion: @escaping (MDBResult<ActorListResponse>) -> Void){
        AF.request(MDBEndpoint.popularPeople(page))
            .responseDecodable(of: ActorListResponse.self){ response in
            // AFDataResponse<ActorInfoResponse>
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularMovieList(page: Int = 1, completion: @escaping (MDBResult<MovieListResult>) -> Void){
        AF.request(MDBEndpoint.popularMovie(page))
            .responseDecodable(of: MovieListResult.self){ response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getTopRatedMovieList(page: Int = 1, completion: @escaping (MDBResult<MovieListResult>) -> Void){
        AF.request(MDBEndpoint.topRatedMovies(page))
            .responseDecodable(of: MovieListResult.self){ response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
            }
        }
    }
    
    
    
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResult>) -> Void){
        AF.request(MDBEndpoint.popularTVSeries)
            .responseDecodable(of: MovieListResult.self){ response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                    
            }
        }
    }
    
    func getGenreList(completion : @escaping (MDBResult<MovieGenreList>) -> Void){
        AF.request(MDBEndpoint.movieGenres)
            .responseDecodable(of: MovieGenreList.self){ response in
            // AFDataResponse<MovieGenreList>
            switch response.result{
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    
    func getUpComingMovieList(completion: @escaping (MDBResult<MovieListResult>) -> Void){
        AF.request(MDBEndpoint.upComingMovie(1))
            .responseDecodable(of: MovieListResult.self){ response in
            // AFDataResponse<MovieListResult>
            switch response.result{
            case .success(let upcomingMovieList):
                completion(.success(upcomingMovieList))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    /*
     Network Error - Differnet Scenarios
     - JSON Serialization Error
     - Wrong URL Path
     - Incorrect Method
     - Missing Credentials
     - 4xx
     - 5xx
     */
    
    // 3 - Customized Error Body
    fileprivate func handleError < T, E: MDBErrorModel>(
        _ response: DataResponse<T, AFError>,
        _ error: (AFError),
        _ errorBodyType : E.Type ) -> String
    {
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        if let respData = response.data{
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            errorBody = try? JSONDecoder().decode( errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        /// 2 - Extract debug info
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        /// 1 - Essential debug Info
        print(
            """
            ========================
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
            ========================
            """
        )
        
        /// 4 - Client dispaly
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
    }
    
}

protocol MDBErrorModel: Decodable{
    var message : String{ get }
}

class MDBCommonResponseError : MDBErrorModel{
    var message: String {
        return statusMessage
    }
    
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys : String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

enum MDBResult<T>{
    case success(T)
    case failure(String)
}
