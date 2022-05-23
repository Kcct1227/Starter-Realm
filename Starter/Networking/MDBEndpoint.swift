//
//  MDBEndpoint.swift
//  Starter
//
//  Created by KC on 17/03/2022.
//

import Foundation
import Alamofire

enum MDBEndpoint : URLConvertible, URLRequestConvertible{
    
    // 1 - enum case with associated value
    case searchMovie(_ page: Int, _ query: String)
    case actorDetail(_ id : Int)
    case actorTVCredits(_ id : Int)
    case trailerVideo(_ id: Int)
    case trailerSeriesVideo(_ id: Int)
    case similarMovie(_ id: Int)
    case movieActors(_ id: Int)
    case seriesActors(_ id: Int)
    case similarSeries(_ id: Int)
    case seriesDetail(_ id : Int)
    case movieDetails(_ id : Int)
    case popularPeople(_ page: Int)
    case popularMovie(_ page: Int)
    case topRatedMovies(_ page: Int)
    case popularTVSeries
    case movieGenres
    case upComingMovie(_ page: Int)
    
    private var baseURL : String{
        return AppConstants.BASEURL
    }

    func asURL() throws -> URL {
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        let request = URLRequest(url: try asURL())
        return request
    }
    
    // 3 - construct URL and append query items
    var url: URL{
        let urlComponents = NSURLComponents(
            string: baseURL.appending(apiPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? apiPath)
        )
        if (urlComponents?.queryItems == nil){
            urlComponents!.queryItems = []
        }
        
        urlComponents!.queryItems!.append(contentsOf: [URLQueryItem(name: "api_key", value: AppConstants.api_key)])
        
        return urlComponents!.url!
    }
    
    
    //// 2 - construct api url
    private var apiPath : String{
        switch self{
        case .searchMovie(let page, let query):
            return "/search/multi?query=\(query)&page=\(page)"
        case .actorDetail(let id):
            return "/person/\(id)"
        case .actorTVCredits(let id):
            return "/person/\(id)/combined_credits"
        case .trailerVideo(let id):
            return "/movie/\(id)/videos"
        case .trailerSeriesVideo(let id):
            return "/tv/\(id)/videos"
        case .similarMovie(let id):
            return "/movie/\(id)/similar"
        case .movieActors(let id):
            return "/movie/\(id)/credits"
        case .seriesActors(let id):
            return "/tv/\(id)/credits"
        case .similarSeries(let id):
            return "/tv/\(id)/similar"
        case .seriesDetail(let id):
            return "/tv/\(id)"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .popularPeople(let page):
            return "/person/popular?page=\(page)"
        case .topRatedMovies(let page):
            return "/movie/top_rated?page=\(page)"
        case .popularMovie(let page):
            return "/movie/popular?page=\(page)"
        case .popularTVSeries:
            return "/tv/popular"
        case .movieGenres:
            return "/genre/movie/list"
        case .upComingMovie(let page):
            return "/movie/upcoming?page=\(page)"
        
        }
    }
}
