//
//  ActorRespository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import CoreData

protocol ActorRepository{
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void)
    func save(list: [ActorInfoResponse])
    func saveDetials(data: ActorDetailResponse)
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void)
    func getTotalPageActorList(completion: @escaping (Int) -> Void)
    func saveActorCombinedList(id: Int, data: [MovieResult])
    func getActorFetchRequestById(_ id: Int) -> NSFetchRequest<ActorEntity>
    func getActorCombinedList(id:Int, completion: @escaping ([MovieResult]) -> Void )
}

class ActorRepositoryImpl : BaseRepository, ActorRepository{
    
    
    static let shared : ActorRepository = ActorRepositoryImpl()
    private let contentTypeRepo = ContentTypeRespositoryImpl.shared

    
    private override init(){}
    private var pageSize = 20
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void) {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            //NSSortDescriptor(key: "insertedAt", ascending: false),
            NSSortDescriptor(key: "popularity", ascending: false)            //NSSortDescriptor(key: "name", ascending: true)
        ]
        fetchRequest.fetchLimit = pageSize // 20
        fetchRequest.fetchOffset = (pageSize * page) - pageSize // 20 - items 21 - 40
        
        do{
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.map { ActorEntity.toActorInfoResponse(entity: $0) })
        }catch {
            print("\(#function) \(error.localizedDescription)")
            completion([ActorInfoResponse]())
        }
    }
    
   
    
    func saveActorCombinedList(id: Int, data: [MovieResult]) {
 
        let fetchRequest : NSFetchRequest<ActorEntity> = getActorFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            data.map{
                $0.toMovieEntity(context: coreData.context, groupTye: contentTypeRepo.getBelongsToTypeEntity(type: .actorCombinedList))
            }.forEach{
                firstItem.addToCredits($0)
            }
            coreData.saveContext()
        }
       
        
    }
    

    func getActorCombinedList(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest<ActorEntity> = getActorFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            completion((firstItem.credits as? Set<MovieEntity>)?.sorted(by:({ (first, second) -> Bool in
                return (second.popularity).isLess(than: first.popularity)
            })).map{
                MovieEntity.toMovieResult(entity: $0)
            } ?? [MovieResult]())
        }
        else{
            completion( [MovieResult]())
        }
    }
    
    
    func save(list: [ActorInfoResponse]) {
        list.forEach{
            let _ = $0.toActorEntity(context: coreData.context)
        }
        coreData.saveContext()
    }
    
    func saveDetials(data: ActorDetailResponse) {
        coreData.context.perform{
            let _ = data.toActorEntity(context: self.coreData.context)

            self.coreData.saveContext()
        }
    }
    
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void) {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        if let items = try?  coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            completion(ActorEntity.toActorDetailResponse(entity: firstItem))
        }else{
            completion(nil)
        }
    }
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void) {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        do{
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.count / pageSize)
        }catch {
            print("\(#function) \(error.localizedDescription)")
            completion(1)
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
