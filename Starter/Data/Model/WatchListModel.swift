//
//  WatchListModel.swift
//  Starter
//
//  Created by KC on 05/05/2022.
//

import Foundation
import CoreData

protocol WatchListModel {
    func initFetchResultController(subscription : WatchListRepoSubscription)
    func deinitFetchResultController()
    func checkMovieId(id: Int, completion: @escaping (Bool) -> Void)
    func getWatchListItems(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func saveWatchMovieId(id: Int, completion: ((MDBResult<String>) -> Void)?)
    func removeMovie(id: Int, completion: ((MDBResult<String>) -> Void)?)
}

class WatchListModelImpl: BaseModel, WatchListModel {
    
    
    
    static let shared : WatchListModel = WatchListModelImpl()
    
    private override init() { }
    
    private let watchListRepository : WatchListRepository = WatchListRepositoryImpl.shared
    
    func initFetchResultController(subscription : WatchListRepoSubscription) {
        watchListRepository.initFetchResultController(subscription: subscription)
    }
    
    func deinitFetchResultController() {
        watchListRepository.deinitFetchResultController()
    }
    
    func checkMovieId(id: Int, completion: @escaping (Bool) -> Void) {
        watchListRepository.getWatchList(id: id) { (item) in
            completion(item != nil)
        }
    }
    
    func getWatchListItems(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        watchListRepository.getWatchListItems { (results) in
            completion(.success(results))
        }
    }
    
    func saveWatchMovieId(id: Int, completion: ((MDBResult<String>) -> Void)?) {
        watchListRepository.saveWatchMovie(id: id) { (results) in
            completion?(results)
        }
    }
    
    func removeMovie(id: Int, completion: ((MDBResult<String>) -> Void)?) {
        watchListRepository.removeMovie(id: id) { (results) in
            completion?(results)
        }
    }
}
