//
//  ActorModel.swift
//  Starter
//
//  Created by KC on 18/03/2022.
//

import Foundation
import RxSwift

protocol ActorModel{
    var totalPageActorList : Int { get set }
    
    func getActorDetailInfoById(id: Int, completion : @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getActorCombinedListById(id: Int, completion : @escaping (MDBResult<[MovieResult]>) -> Void)
    func getPopularPeople(page:Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]>

    
    
}

class ActorModelImpl : BaseModel, ActorModel{
    
    
    
    
    static let shared = ActorModelImpl()
    
    private let actorRepository : ActorRepository = ActorRepositoryImpl.shared
    private let movieRepository : MovieRepository = MovieRespositoryImpl.shared
    private let contentRepository : ContentTypeRepository = ContentTypeRespositoryImpl.shared
    
    var totalPageActorList : Int = 1
    
    private override init() {}
    
    
    
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]> {
        var networkResult = [ActorInfoResponse]()
        networkAgent.getPopularPeople(page: page) { (result) in
            switch result {
            case .success(let data):
                networkResult = data.results ?? [ActorInfoResponse]()
                self.actorRepository.save(list: data.results ?? [ActorInfoResponse]())
                self.totalPageActorList = data.totalPages ?? 1
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            if networkResult.isEmpty {
                /// Update Total Pages available to fetch
                self.actorRepository.getTotalPageActorList { self.totalPageActorList = $0 }
            }
        }
        
        return self.actorRepository.getList(page: page)
    }
    
    func getActorDetailInfoById(id: Int, completion : @escaping (MDBResult<ActorDetailResponse>) -> Void){
        networkAgent.getActorDetailInfoById(id: id){ (result) in
            switch result {
            case .success(let data) :
                self.actorRepository.saveDetials(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.actorRepository.getDetails(id: id){ data in
                if let data = data{
                    completion(.success(data))
                }
                else{
                    completion(.failure("Couldn't find actor with id \(id)"))
                }
            }
            
        }
    }
    
    func getActorCombinedListById(id: Int, completion : @escaping (MDBResult<[MovieResult]>) -> Void){
        //networkAgent.getActorCombinedListById(id: id, completion: completion)
        networkAgent.getActorCombinedListById(id: id){ (result) in
            switch result {
            case .success(let data) :
                self.actorRepository.saveActorCombinedList(id: id, data: data.cast ?? [MovieResult]())
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.actorRepository.getActorCombinedList(id: id){
                completion(.success($0))
            }
            
        }
    }
    
    func getPopularPeople(page:Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void){
        var networkResult = [ActorInfoResponse]()

        networkAgent.getPopularPeople(page: page){ (result) in
            switch result {
            case .success(let data):
                networkResult = data.results ?? [ActorInfoResponse]()
                self.actorRepository.save(list: data.results ?? [ActorInfoResponse]())
                self.totalPageActorList = data.totalPages ?? 1
            case .failure(let error) :
                print("\(#function) \(error)")
            }
            
            if networkResult.isEmpty{
                self.actorRepository.getTotalPageActorList{
                    self.totalPageActorList = $0
                }
            }
            self.actorRepository.getList(page: page, type: .popularActors){
                completion(.success(ActorListResponse(dates: nil, page: page, results: $0, totalPages:self.totalPageActorList, totalResults: 1)))
            }
           
            
        }
    }
    
   

}
