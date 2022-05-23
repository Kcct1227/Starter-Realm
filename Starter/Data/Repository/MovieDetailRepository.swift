//
//  MovieDetailRepository.swift
//  Starter
//
//  Created by KC on 10/05/2022.
//

import Foundation
import CoreData
import RxSwift

protocol MovieDetailRepository {
    func deinitMovieResultController()
    func getSimilarMoviesObservable() -> Observable<[MovieResult]>
    func getMovieCastObservable() -> Observable<[MovieCast]>

    func getMovieDetailObservable() -> Observable<MovieDetailResponse>
    func initFetchResultController(id: Int)
}


class MovieDetailRepositoryImpl: BaseRepository, MovieDetailRepository{
    
    static let shared : MovieDetailRepository = MovieDetailRepositoryImpl()
    private let movieRepository : MovieRepository = MovieRespositoryImpl.shared

    
    private var fectchMovieResultController: NSFetchedResultsController<MovieEntity>?
    private var similarMovies : BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    private var movieCasts : BehaviorSubject<[MovieCast]> = BehaviorSubject(value: [])
    private var movieDetail : BehaviorSubject<MovieDetailResponse> = BehaviorSubject(value: MovieDetailResponse.empty())


    
    /// Only single subscriber allowed for now
   //// private var subscription : MovieDetailSubscription?
    private var id: Int?
    
    private override init() {
        super.init()
    }
    
    func initFetchResultController(id: Int) {
        
        let fetchRequest = movieRepository.getMovieFetchRequestById(id)
    
        self.fectchMovieResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        self.id = id 
        self.fectchMovieResultController?.delegate = self
        do {
            try fectchMovieResultController?.performFetch()
            //didChange()
            //didChangeDetail()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func getMovieDetailObservable() -> Observable<MovieDetailResponse>{
        do {
            try fectchMovieResultController?.performFetch()
            didChangeDetail()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        return movieDetail
        
    }
    
    func getMovieCastObservable() -> Observable<[MovieCast]> {
        do {
            try fectchMovieResultController?.performFetch()
            didChangeMovieCasts()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
        return movieCasts
    }
    

    
    func getSimilarMoviesObservable() -> Observable<[MovieResult]> {
        
       // self.subscription = subscription
        //self.id = id
     
        
        do {
            try fectchMovieResultController?.performFetch()
            didChange()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return similarMovies
    }
    
    func deinitMovieResultController() {
        self.fectchMovieResultController = nil
    }
    
    func didChangeDetail()  {
        // notify all subscribers for new data
        
        if let item = fectchMovieResultController?.fetchedObjects?.first{
            movieDetail.onNext(MovieEntity.toMovieDetailResponse(
                entity: item,
                companyList: movieRepository.getCompanies(id: id ?? 0),
                countryList: movieRepository.getCountry(id: id ?? 0)))
        }
     
    }
    
    func didChangeMovieCasts(){
        if let item = fectchMovieResultController?.fetchedObjects?.first{
            if let actorEntites = (item.casts as? Set<ActorEntity>){
                movieCasts.onNext(actorEntites.map{
                    ActorEntity.toMovieCast(entity: $0)
                })
            }
        }
    }
    
    
    func didChange()  {
        // notify all subscribers for new data        
        if let item = fectchMovieResultController?.fetchedObjects?.first{
            let data = (item.similarMovies as? Set<MovieEntity>)?.map{
                MovieEntity.toMovieResult(entity: $0)
            } ?? [MovieResult]()
            
            similarMovies.onNext(data)
        }
       
        
     
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate
extension MovieDetailRepositoryImpl: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
            didChange()
            didChangeDetail()
            didChangeMovieCasts()
            
    }
}
