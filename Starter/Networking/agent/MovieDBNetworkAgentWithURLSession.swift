//
//  MovieDBNetworkAgentWithURLSession.swift
//  Starter
//
//  Created by KC on 17/03/2022.
//

import Foundation

class MovieDBNetworkAgentWithURLSession : MovieDBNetworkAgentProtocol{
    
    
    
   static let shared = MovieDBNetworkAgentWithURLSession()
    
    private init(){}
    
    
    func getSeriesTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void){
        
    }
    
    func getSeriesCreditByid(id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        
    }
    
    func getSearchMovie(name: String, page: Int, completion: @escaping (MDBResult<MovieListResult>) -> Void) {
                
    }
    
    func getActorDetailInfoById(id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
    
    }
    
    func getActorCombinedListById(id: Int, completion: @escaping (MDBResult<ActorCombinedList>) -> Void) {
        
    }
    
    func getMovieTrailerVideo(id: Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        
    }
    
    func getSimilarMovieById(id: Int, completion: @escaping (MDBResult<MovieListResult>) -> Void) {
        
    }
    
    func getSimilarSeriesById(id: Int, completion: @escaping (MDBResult<MovieListResult>) -> Void) {
        
    }
    
    func getMovieCreditByid(id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        
    
    }
    
    func getSeriesDetailById(id: Int, completion: @escaping (MDBResult<SeriesDetailResponse>) -> Void) {
    
    }
    
    func getMovieDetailById(id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
    
    }
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
    
    }
    
    func getPopularMovieList(page: Int, completion: @escaping (MDBResult<MovieListResult>) -> Void) {
    
    }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResult>) -> Void) {
    
    }
    
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResult>) -> Void) {
    
    }
    
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
    
    }
    
    func getUpComingMovieList(completion: @escaping (MDBResult<MovieListResult>) -> Void) {
        let url = URL(string: "\(AppConstants.BASEURL)/movie/upcoming?api_key=\(AppConstants.api_key)")!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data{
                let upcomingMovieList = try! JSONDecoder().decode(MovieListResult.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(upcomingMovieList))
                }
            }
        }.resume()
    }
    
    
}
