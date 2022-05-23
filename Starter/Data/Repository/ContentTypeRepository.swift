//
//  ContentTypeRepository.swift
//  Starter
//
//  Created by KC on 23/03/2022.
//

import Foundation
import CoreData
import CoreData
import RxSwift
import RealmSwift
import RxRealm

protocol ContentTypeRepository {
    func save(name: String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity
    
    func getList(page: Int, type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    
    func getTopRatedTotalPages(type: MovieSerieGroupType, completion: @escaping (Int) -> Void)
    
    func getBelongsToTypeObject(type : MovieSerieGroupType) -> BelongsToTypeObject
}

class ContentTypeRespositoryImpl: BaseRepository, ContentTypeRepository {
    
    static let shared : ContentTypeRespositoryImpl = ContentTypeRespositoryImpl()

    private var contentTypeMap = [String: BelongsToTypeObject]()
    
    private var pageSize = 20

    
    private override init(){
        super.init()
        //initializeData()
    }
    
    
    var notificationToken : NotificationToken?
    
    private func initializeData() {
           
           let dataSource = realmDB.objects(BelongsToTypeObject.self)
           
           if dataSource.isEmpty {
               /// Insert initial data
               MovieSerieGroupType.allCases.forEach {
                   let _ : BelongsToTypeObject = save(name: $0.rawValue)
               }
           } else {
               /// Map existing data
               dataSource.forEach {
                   contentTypeMap[$0.name ] = $0
               }
               
             notificationToken =  dataSource.observe{ (changes) in
                   switch changes {
                   case .initial(let objects):
                       print(objects.count)
                   case .update(let objectes, let deletions, let insertions, let modifications) :
                       print(objectes.count)
                       print("Inserted Index : \(insertions.map { "\($0)" }.joined(separator: ","))")
                       print("Deleted Index : \(deletions.map { "\($0)" }.joined(separator: ","))")
                       print("Modified Index : \(modifications.map { "\($0)" }.joined(separator: ","))")
                   case .error(let error) :
                       print(error.localizedDescription)
                   }
            
               
                   
               }
               
               
           }
    }
    
    func save(name: String) -> BelongsToTypeObject {
            let object = BelongsToTypeObject()
            object.name = name
            
            contentTypeMap[name] = object
            
            try! realmDB.write {
                realmDB.add(object, update: .modified)
            }
            return object
        }
    
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        coreData.saveContext()
        return entity
    }
    
    
   
    
    func getList(page: Int, type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        
        if let object = contentTypeMap[type.rawValue] {
            let items = object.movies.sorted(by: { (first, second) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                
                return firstDate.compare(secondDate) == .orderedDescending
            }).map {
                $0.toMovieResult()
            }
            completion(items)
        } else {
            completion([MovieResult]())
        }
        
//        let items:[BelongToType] = realmDB.objects(BelongsToTypeObject.self)
//            .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "name", type.rawValue))
//            .map{ $0.toBelongToType() }
//        if let firstItem = items.first{
//            completion(Array(firstItem.movies ?? [MovieResult]()).sorted(by: { (first, second) -> Bool in
//                let dataFormatter = DateFormatter()
//                dataFormatter.dateFormat = "yyyy-MM-dd"
//                let firstDate = dataFormatter.date(from: first.releaseDate ?? "") ?? Date()
//                let secondDate = dataFormatter.date(from: second.releaseDate ?? "" ) ?? Date()
//                return firstDate.compare(secondDate) == .orderedAscending
//            }))
//        }
//        else{
//            completion([MovieResult]())
//        }
    }
    
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        if let object = contentTypeMap[type.rawValue] {
            let items = object.movies.sorted(by: { (first, second) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                
                return firstDate.compare(secondDate) == .orderedDescending
            }).map {
                $0.toMovieResult()
            }
            completion(items)
        } else {
            completion([MovieResult]())
        }
    }
    
    func getMoviesOrSeries(type : MovieSerieGroupType) -> Observable<[MovieResult]> {
        let items:[BelongsToTypeObject] = self.realmDB.objects(BelongsToTypeObject.self)
            .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "name", type.rawValue))
            .map{ $0 }
        if let firstItem = items.first{
            return Observable.collection(from: firstItem.movies)
                .flatMap { movies -> Observable<[MovieResult]> in
                    return Observable.create { (observer) -> Disposable in
                        let items : [MovieResult] = movies.sorted(by: self.sortMoviesByDate)
                            .map { $0.toMovieResult() }
                        observer.onNext(items)
                        return Disposables.create()
                    }
            }
        }
        print("-------------- empty")
        return Observable.empty()
        
        
        /*
         if let object : BelongsToTypeObject = self.contentTypeMap[type.rawValue] {
             return Observable.collection(from: object.movies)
                 .flatMap { movies -> Observable<[MovieResult]> in
                     return Observable.create { (observer) -> Disposable in
                         let items : [MovieResult] = movies.sorted(by: self.sortMoviesByDate)
                             .map { $0.toMovieResult() }
                         observer.onNext(items)
                         return Disposables.create()
                     }
                 }
         }
         
         return Observable.empty()
         */
        
        
        
        
//        return Observable.create { (observer) -> Disposable in
//
//            var notificationToken: NotificationToken?
//
//            if let object : BelongsToTypeObject = self.contentTypeMap[type.rawValue]{
//                var movieObjects : [MovieResultObject] = [MovieResultObject]()
//
//                notificationToken = object.movies.observe({ (change) in
//                    switch change{
//                    case .initial(let objects):
//                        movieObjects = objects.toArray()
//                    case .update(let objects, _, _, _):
//                        movieObjects = objects.toArray()
//                    case .error(let error):
//                        observer.onError(error)
//                    }
//
//                    let resultItems = movieObjects.map{ $0.toMovieResult() }
//                    observer.onNext(resultItems)
//                })
//            }
//            else{
//                observer.onError(MDBError.withMessage("Failed to get \(type.rawValue) from database"))
//            }
//            return Disposables.create(){
//                notificationToken?.invalidate()
//            }
//
//
//        }
        

    }
    
    private func sortMoviesByDate(first: MovieResultObject, second: MovieResultObject) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
        let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
        
        return firstDate.compare(secondDate) == .orderedDescending
    }
    
    func getBelongsToTypeObject(type : MovieSerieGroupType) -> BelongsToTypeObject {
        if let object = contentTypeMap[type.rawValue] {
            return object
        }
        
        return save(name: type.rawValue)
    }
    
    
//    
//    func getMoviesOrSeries1(type: MovieSerieGroupType) -> Observable<[MovieResult]> {
//        return Observable.create{ (observer) -> Disposable in
//            var notificationToken: NotificationToken?
//            
//            let items:[BelongsToTypeObject] = self.realmDB.objects(BelongsToTypeObject.self)
//                .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "name", type.rawValue))
//                .map{ $0 }
//            
//            if let firstItem = items.first{
//                //completion(firstItem.movies ?? [MovieResult]())
//                var movieObjects : [MovieResultObject] = [MovieResultObject]()
//        
//                
//                notificationToken = firstItem.movieList.observe({ (change) in
//                    switch change {
//                    case .initial(let objects):
//                        movieObjects.removeAll()
//                        movieObjects.append(contentsOf: objects)
//                    case .update(let objects, _, _, _):
//                        movieObjects.removeAll()
//                        movieObjects.append(contentsOf: objects)
//                    case .error(let error):
//                        observer.onError(error)
//                    }
//                    
//                    let resultItems = movieObjects
//                        .map {
//                            $0.toMovieResult()
//                        }
//                    observer.onNext(resultItems)
//                    
//                })
//            }
//            else{
//                observer.onError(MDBError.withMessage("Failed to get \(type.rawValue) from database"))
//            }
//            
//            return Disposables.create(){
//                notificationToken?.invalidate()
//            }
//            
//        }
//    }
    
    func getTopRatedTotalPages(type: MovieSerieGroupType, completion: @escaping (Int) -> Void) {
 
    }
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType) -> BelongsToTypeEntity {
        return BelongsToTypeEntity()
    
    }
        
    
    
}
    
    
   
    
    
   

