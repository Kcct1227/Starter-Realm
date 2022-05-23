//
//  ContentTypeRepository.swift
//  Starter
//
//  Created by KC on 23/03/2022.
//

import Foundation
import CoreData
import Alamofire
import RxCocoa
import RxSwift

protocol ContentTypeRepository {
    func save(name: String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity
    
    func getList(page: Int, type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    
    func getTopRatedTotalPages(type: MovieSerieGroupType, completion: @escaping (Int) -> Void)
    
    func testing()

}

class ContentTypeRespositoryImpl: BaseRepository, ContentTypeRepository{
    
    
    static let shared : ContentTypeRespositoryImpl = ContentTypeRespositoryImpl()

    private var contentTypeMap = [String: BelongsToTypeEntity]()
    
    private var pageSize = 20

    
    private override init(){
        super.init()
        initializeData()
    }
    
    private func initializeData(){
        // Process Existiing Data
        
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        do{
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            if dataSource.isEmpty{
                // Insert Initial data
                MovieSerieGroupType.allCases.forEach{
                    let _ = save(name: $0.rawValue)
                }
            }
            else{
                // Map existing data
                dataSource.forEach{
                    if let key = $0.name{
                        contentTypeMap[key] = $0
                    }
                }
            }
        }catch{
            print(error)
        }
    }
    
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        coreData.saveContext()
        return entity
    }
    
    func testing() {
        DispatchQueue.global().async {
            if let entity = self.contentTypeMap[MovieSerieGroupType.upcomingMovies.rawValue],
               let movies = entity.movies,
               let itemSet = movies as? Set<MovieEntity>{
                 let data = Array( itemSet.sorted(by: { (first, second) -> Bool in
                     let dataFormatter = DateFormatter()
                     dataFormatter.dateFormat = "yyyy-MM-dd"
                     let firstDate = dataFormatter.date(from: first.releaseDate ?? "") ?? Date()
                     let secondDate = dataFormatter.date(from: second.releaseDate ?? "" ) ?? Date()
                     return firstDate.compare(secondDate) == .orderedDescending
                 })).map{ MovieEntity.toMovieResult(entity: $0)}
                print("!!!!!!!!! \(data.count)")
             }
             
            
        }
    }

    
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        
       if let entity = contentTypeMap[type.rawValue],
          let movies = entity.movies,
           let itemSet = movies as? Set<MovieEntity>{
            completion( Array( itemSet.sorted(by: { (first, second) -> Bool in
                let dataFormatter = DateFormatter()
                dataFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dataFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dataFormatter.date(from: second.releaseDate ?? "" ) ?? Date()
                return firstDate.compare(secondDate) == .orderedDescending
            })).map{ MovieEntity.toMovieResult(entity: $0)})
        }
        else{
            completion([MovieResult]())
        }
        
    }
    
    func fetchBelongToRequest(type: MovieSerieGroupType) -> NSFetchRequest<BelongsToTypeEntity>{
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "name", type.rawValue)
        return fetchRequest
    }
    
    func getList(page: Int, type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest: NSFetchRequest<MovieEntity> = fetchResquestByBelongToType(type: type)
        fetchRequest.fetchLimit = pageSize // 20
        fetchRequest.fetchOffset = (pageSize * page) - pageSize // 20 - items 21 - 40
        do{
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.map { MovieEntity.toMovieResult(entity: $0) })
        }catch {
            print("\(#function) \(error.localizedDescription)")
            completion([MovieResult]())
        }

    }
    
    private func fetchResquestByBelongToType(type: MovieSerieGroupType) -> NSFetchRequest<MovieEntity>{
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "voteAverage", ascending: false),
            NSSortDescriptor(key: "popularity", ascending: false),
        ]
        fetchRequest.predicate = NSPredicate(format: "belongsToType.name CONTAINS[cd] %@", type.rawValue)
        return fetchRequest
    }
    
    func getTopRatedTotalPages(type: MovieSerieGroupType, completion: @escaping (Int) -> Void) {
                
        let fetchRequest : NSFetchRequest<MovieEntity> = fetchResquestByBelongToType(type: type)
        do{
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.count / pageSize)
        }catch {
            print("\(#function) \(error.localizedDescription)")
            completion(1)
        }
    }
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity {
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = fetchBelongToRequest(type: type)
        do{
            let results : [BelongsToTypeEntity] = try coreData.context.fetch(fetchRequest)
            return results[0]
        }catch{
            print("\(#function) \(error.localizedDescription)")
            return BelongsToTypeEntity()
        }
    
    }
    
   
}

/*
 @discardableResult
 func save(name: String) -> BelongsToTypeEntity {
     let entity = BelongsToTypeEntity(context: coreData.context)
     entity.name = name
     contentTypeMap[name] = entity
     coreData.saveContext()
     return entity
 }
 
 func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
     
 }
 
 func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity {
     if let entity = contentTypeMap[type.rawValue]{
         return entity
     }
     return save(name: type.rawValue)
 
 }
 */
