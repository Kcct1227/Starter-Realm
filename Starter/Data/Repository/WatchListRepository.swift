//
//  WatchListRepository.swift
//  Starter
//
//  Created by KC on 05/05/2022.
//

import Foundation
import CoreData

protocol WatchListRepository {
    func initFetchResultController(subscription : WatchListRepoSubscription)
    func deinitFetchResultController()
    func getWatchList( id : Int, completion: @escaping (WatchListEntity?) -> Void)
    func getWatchListItems(completion: @escaping ([MovieResult]) -> Void)
    func saveWatchMovie(id: Int, completion: @escaping (MDBResult<String>) -> Void)
    func removeMovie(id: Int, completion: @escaping (MDBResult<String>) -> Void)
}

protocol WatchListRepoSubscription {
    func onFetchResultDidChange(didChange objects: [MovieResult])
}

class WatchListRepositoryImpl: BaseRepository, WatchListRepository {
   
  
    static let shared : WatchListRepository = WatchListRepositoryImpl()
    private let movieRepository : MovieRepository = MovieRespositoryImpl.shared

    private var fetchResultController: NSFetchedResultsController<WatchListEntity>?
    
    /// Only single subscriber allowed for now
    private var subscription : WatchListRepoSubscription?
    
    private override init() {
        super.init()
    }
    
    func initFetchResultController(subscription : WatchListRepoSubscription) {
        
        self.subscription = subscription
        
        let fetchRequest = fetchRequestAll()
        self.fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        self.fetchResultController?.delegate = self
        
        do {
            try fetchResultController?.performFetch()
            
            notifyChangesToSubscriber()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func deinitFetchResultController() {
        self.subscription = nil
        self.fetchResultController = nil
    }
    
    func getWatchList(id: Int, completion: @escaping (WatchListEntity?) -> Void) {
        let fetchRequest : NSFetchRequest<WatchListEntity> = WatchListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "movieId", "\(id)")
        completion(try? coreData.context.fetch(fetchRequest).first)
    }
    
    func getWatchListItems(completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest<WatchListEntity> = WatchListEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "insertedAt", ascending: false)
        ]
        
        let results = try? coreData.context.fetch(fetchRequest)
        let movieItems : [MovieResult] = results?
            .map { Int($0.movieId) }
            .map {
                let fetchRequest = movieRepository.getMovieFetchRequestById($0)
                let items = try? coreData.context.fetch(fetchRequest)
                return items?.first
            }
            .compactMap { $0 }
            .map {
                MovieEntity.toMovieResult(entity: $0)
            } ?? [MovieResult]()
            
        completion(movieItems)
    }
    
    func saveWatchMovie(id: Int, completion: @escaping (MDBResult<String>) -> Void) {
        movieRepository.getDetail(id: id) { [unowned self] (movieDetailResponse) in
            let entity = WatchListEntity(context: self.coreData.context)
            entity.movieId = Int32(id)
            entity.insertedAt = Date()
            self.coreData.saveContext()
            
        }
    }
    
    func removeMovie(id: Int, completion: @escaping (MDBResult<String>) -> Void) {
        let fetchRequest : NSFetchRequest<WatchListEntity> = WatchListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "movieId", "\(id)")
        
        if let watchListItems = try? coreData.context.fetch(fetchRequest),
           let item = watchListItems.first {
            
            coreData.context.delete(item)
            
            coreData.saveContext()
            
            completion(.success("Removed!"))
        } else {
            completion(.failure("Failed to remove!"))
        }
    }
    
    private func fetchRequestAll() -> NSFetchRequest<WatchListEntity> {
        let fetchRequest : NSFetchRequest<WatchListEntity> = WatchListEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "insertedAt", ascending: false)
        ]
        return fetchRequest
    }
    
    
    private func notifyChangesToSubscriber() {
        // notify all subscribers for new data
        subscription?.onFetchResultDidChange(
            didChange: fetchResultController?.fetchedObjects?
                .map { Int($0.movieId) }
                .map {
                    let fetchRequest = movieRepository.getMovieFetchRequestById($0)
                    let items = try? coreData.context.fetch(fetchRequest)
                    return items?.first
                }
                .compactMap { $0 }
                .map {
                    MovieEntity.toMovieResult(entity: $0)
                } ?? [MovieResult]())
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate
extension WatchListRepositoryImpl: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
       notifyChangesToSubscriber()
        
    }

    
}
