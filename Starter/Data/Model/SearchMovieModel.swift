//
//  SearchMovieModel.swift
//  Starter
//
//  Created by KC on 18/03/2022.
//

import Foundation

protocol SearchMovieModel{
    func getSearchMovie(name: String, page: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void)
}

class SearchMovieModelImpl : BaseModel, SearchMovieModel{
    
    static let shared = SearchMovieModelImpl()
    
    private override init() {}

    
    func getSearchMovie(name: String, page: Int, completion : @escaping (MDBResult<MovieListResult>) -> Void){
        networkAgent.getSearchMovie(name: name, page: page, completion: completion)
    }
    
}
