//
//  SeriesModel.swift
//  Starter
//
//  Created by KC on 18/03/2022.
//

import Foundation

protocol SeriesModel{
    func getSimilarSeriesById(id: Int, completion : @escaping (MDBResult<[MovieResult]>) -> Void)
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getSeriesDetailById(id : Int, completion : @escaping (MDBResult<SeriesDetailResponse>) -> Void)
    func getSeriesCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getSeriesTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void)

}

class SeriesModelImpl : BaseModel, SeriesModel{
    
    static let shared = SeriesModelImpl()
    private let movieRespository : MovieRepository = MovieRespositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRespositoryImpl.shared
    
    private override init() {}
        
    func getSimilarSeriesById(id: Int, completion : @escaping (MDBResult<[MovieResult]>) -> Void){
        //networkAgent.getSimilarSeriesById(id: id, completion: completion)
        networkAgent.getSimilarSeriesById(id: id){ (result) in
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
    
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void){
        let contentType : MovieSerieGroupType = .popularSeries
        networkAgent.getPopularSeriesList(){ (result) in
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
    
    func getSeriesDetailById(id : Int, completion : @escaping (MDBResult<SeriesDetailResponse>) -> Void){
        //networkAgent.getSeriesDetailById(id: id, completion: completion)
        networkAgent.getSeriesDetailById(id: id){ (result) in
            switch result {
            case .success(let data) :
                
                self.movieRespository.saveDetail( data: data.toMovieDetailResponse())
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRespository.getDetail(id: id){ (item) in
                if let item = item{
                    completion(.success(item.toSeriesDetailResonse()))
                }
                else{
                    completion(.failure("Failed to get detail with id \(id)"))
                }
                
            }
        }

    }
    

    
    func getSeriesCreditByid(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void){
        //networkAgent.getSeriesCreditByid(id: id, completion: completion)
        networkAgent.getSeriesCreditByid(id: id){ (result) in
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
    
    func getSeriesTrailerVideo(id: Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void){
        networkAgent.getSeriesTrailerVideo(id: id, completion: completion)
    }

    
}
