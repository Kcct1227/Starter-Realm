//
//  ActorModel.swift
//  Starter
//
//  Created by KC on 18/03/2022.
//

import Foundation
import RxSwift
import RxAlamofire

protocol ActorModel{
    var totalPageActorList : Int { get set }
    
    func getActorDetailInfoById(id: Int, completion : @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getActorCombinedListById(id: Int, completion : @escaping (MDBResult<[MovieResult]>) -> Void)
    func getPopularPeople(page:Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void)
    
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]>
    func getDetails(id: Int)
    func getActorCombinedList(id: Int)
}

class ActorModelImpl : BaseModel, ActorModel{
    
    
    let disposeBag = DisposeBag()
    
    static let shared = ActorModelImpl()
    
    private let actorRepository : ActorRepository = ActorRepositoryImpl.shared
    private let movieRepository : MovieRepository = MovieRespositoryImpl.shared
    private let contentRepository : ContentTypeRepository = ContentTypeRespositoryImpl.shared
    
    var totalPageActorList : Int = 1
    
    private override init() {}
    
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
    
    func getDetails(id: Int) {
        
        
        RxNetworkAgent.shared.getActorDetailById(id: id)
            .subscribe(onNext : { data in
                self.actorRepository.saveDetials(data: data)

            }).disposed(by: disposeBag)
        
    }
    
    func getActorCombinedList(id: Int) {

        RxNetworkAgent.shared.getActorCombinedList(id: id)
            .subscribe(onNext : { data in

                self.actorRepository.saveActorCombinedList(id: id, data: data.cast ?? [MovieResult]())

            }).disposed(by: disposeBag)
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
    
    func getPopularPeople(page:Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void){
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
                completion(.success($0))
            }
           
            
        }
    }
    
    
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]> {
        var networkResult = [ActorInfoResponse]()

        return RxNetworkAgent.shared.getPopularPeople(page: page)
                .do(onNext: { data in
                    networkResult = data.results ?? [ActorInfoResponse]()
                    self.actorRepository.save(list: data.results ?? [ActorInfoResponse]())
                    self.totalPageActorList = data.totalPages ?? 1

                    
                })
                    .catchAndReturn(ActorListResponse.empty())
                    .flatMap{ _ ->  Observable<[ActorInfoResponse]> in
                        return Observable.create{ (observer) -> Disposable in
                            if networkResult.isEmpty{
                                self.actorRepository.getTotalPageActorList{
                                    self.totalPageActorList = $0
                                }
                            }
                            self.actorRepository.getList(page: page, type: .popularActors){
                                observer.onNext($0)
                                observer.onCompleted()
                                
                            }
                            
                return Disposables.create()
            }
        }
    }
    
    
   

}
