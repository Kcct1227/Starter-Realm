//
//  ActorDetailRepository.swift
//  Starter
//
//  Created by KC on 10/05/2022.
//

import Foundation
import CoreData
import RxSwift

protocol ActorDetailRepository {
    
    func deinitActorResultController()
    func getActorMovieContentObservable() -> Observable<[MovieResult]>
    func getActorDetailObservable() -> Observable<ActorDetailResponse>
    func initActorFetchResultController(id: Int)

}


class ActorDetailRepositoryImpl: BaseRepository, ActorDetailRepository{
    
    static let shared : ActorDetailRepository = ActorDetailRepositoryImpl()
    private let movieRepository : MovieRepository = MovieRespositoryImpl.shared

    
    private var fetchActorCombinedController: NSFetchedResultsController<ActorEntity>?
    private var similarMovies : BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    private var actorDetails : BehaviorSubject<ActorDetailResponse> = BehaviorSubject(value: ActorDetailResponse.empty())
    
    
    private override init() {
        super.init()
    }
    
    func initActorFetchResultController(id: Int) {
        
        let fetchRequest = getActorFetchRequestById(id)
        self.fetchActorCombinedController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        self.fetchActorCombinedController?.delegate = self
        
        do {
            try fetchActorCombinedController?.performFetch()
            
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }

    func deinitActorResultController() {
        self.fetchActorCombinedController = nil
    }
    
    func getActorMovieContentObservable() -> Observable<[MovieResult]> {
        do {
            try fetchActorCombinedController?.performFetch()
            didChange()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return similarMovies
    }
    
    func getActorDetailObservable() -> Observable<ActorDetailResponse> {
        do {
            try fetchActorCombinedController?.performFetch()
            didChangeDetail()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        return actorDetails
    }
    
    
    func didChangeDetail()  {
        // notify all subscribers for new data
        
        if let item = fetchActorCombinedController?.fetchedObjects?.first{
            actorDetails.onNext(ActorEntity.toActorDetailResponse(entity: item ))
        }
     
    }
    
    func didChange()  {
        // notify all subscribers for new data
        if let item = fetchActorCombinedController?.fetchedObjects?.first{
            let data = ((item.credits as? Set<MovieEntity>)?.sorted(by:({ (first, second) -> Bool in
                return (second.popularity).isLess(than: first.popularity)
            })).map{
                MovieEntity.toMovieResult(entity: $0)
            } ?? [MovieResult]())
            
            similarMovies.onNext(data)
        }

    }

    func getActorFetchRequestById(_ id: Int) -> NSFetchRequest<ActorEntity>{
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
    }
    

    
}

//MARK: - NSFetchedResultsControllerDelegate
extension ActorDetailRepositoryImpl: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        didChange()
        didChangeDetail()
    }
    

    
}
