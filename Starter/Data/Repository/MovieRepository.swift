//
//  MovieRepository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import CoreData

protocol MovieRepository{
    func getDetail(id:Int, completion: @escaping (MovieDetailResponse?) -> Void )
    func saveDetail(data: MovieDetailResponse)
    func saveList(type: MovieSerieGroupType, data: MovieListResult)
    func saveSimilarContent(id: Int, data: [MovieResult])
    func getSimilarContent(id:Int, completion: @escaping ([MovieResult]) -> Void )
    func saveCasts(id: Int, data: [MovieCast])
    func getCasts(id:Int, completion: @escaping ([MovieCast]) -> Void )
    func getMovieFetchRequestById(_ id: Int) -> NSFetchRequest<MovieEntity>
    func getCountry(id: Int) -> [ProductionCountry]
    func getCompanies(id: Int) -> [ProductionCompany] 
    
}

class MovieRespositoryImpl: BaseRepository, MovieRepository{
    
    static let shared : MovieRepository = MovieRespositoryImpl()
    private let contentTypeRepo = ContentTypeRespositoryImpl.shared
    
    private override init() { }
    
    func saveList(type: MovieSerieGroupType, data: MovieListResult) {
        
        coreData.context.perform {
            data.results?.forEach{
                $0.toMovieEntity(
                    context: self.coreData.context,
                    groupTye: self.contentTypeRepo.getBelongsToTypeEntity(type: type)
                )
                
            }
            self.coreData.saveContext()
        }
    }
    
    
    func getDetail(id: Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        
        
        
        coreData.context.perform {
            let fetcthRequest: NSFetchRequest<MovieEntity> = self.getMovieFetchRequestById(id)
            
            if let items = try?  self.coreData.context.fetch(fetcthRequest),
               let firstItem = items.first{
                completion(MovieEntity.toMovieDetailResponse(entity: firstItem, companyList: self.getCompanies(id: id), countryList:  self.getCountry(id: id)))
            }else{
                completion(nil)
            }
        }
    }
    
    func getCompanies(id: Int) -> [ProductionCompany] {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            return (firstItem.productionCompanies as? Set<ProductionCompanyEntity>)?.map{
                ProductionCompanyEntity.toProductionCompay(entity: $0)
            } ?? [ProductionCompany]()
        }
        else{
            return [ProductionCompany]()
        }
    }
    
    func getCountry(id: Int) -> [ProductionCountry] {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            return (firstItem.productionCountry as? Set<ProductionCountryEntity>)?.map{
                ProductionCountryEntity.toProductionCountry(entity: $0)
            } ?? [ProductionCountry]()
        }
        else{
            return [ProductionCountry]()
        }
    }
    
    func saveDetail(data: MovieDetailResponse) {
        coreData.context.perform {

            let _ = data.toMovieEntity(context: self.coreData.context)
            self.saveCompanies(id: data.id ?? 0, data: data.productionCompanies ?? [ProductionCompany]())
            
            self.saveCountry(id: data.id ?? 0, data: data.productionCountries ?? [ProductionCountry]())
            self.coreData.saveContext()
        }
        
    }
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            data.map{
                $0.toMovieEntity(
                    context: coreData.context,
                    groupTye: contentTypeRepo.getBelongsToTypeEntity(type: .actorCredits))
            }.forEach{
                firstItem.addToSimilarMovies($0)
            }
            coreData.saveContext()
        }
        
    }
    
   
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            completion(
                (firstItem.similarMovies as? Set<MovieEntity>)?.map{
                    MovieEntity.toMovieResult(entity: $0)
                } ?? [MovieResult]()
            )
        }
    }
    
    
    func saveCompanies(id: Int, data: [ProductionCompany]) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            data.map{
                $0.toMovieProductonCompany(conext: coreData.context)
            }.forEach{
                firstItem.addToProductionCompanies($0)
            }
            coreData.saveContext()
        }
        
    }
    
    func saveCountry(id: Int, data: [ProductionCountry]) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            data.map{
                $0.toMovieProductionCountry(context: coreData.context)
            }.forEach{
                firstItem.addToProductionCountry($0)
            }
            coreData.saveContext()
        }
        
    }
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first,
           let actorEntites = (firstItem.casts as? Set<ActorEntity>){
            completion(
                actorEntites.map{
                    
                    ActorEntity.toMovieCast(entity: $0)
                }
            )
        }
        
    }
    
    func saveCasts(id: Int, data: [MovieCast]) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            data.map{
                $0.convertToActorInfoResponse()
            }.map {
                $0.toActorEntity(context: coreData.context)
            }.forEach{
                firstItem.addToCasts($0)
            }
        
            coreData.saveContext()
        }
    }
    
  
    
     func getMovieFetchRequestById(_ id: Int) -> NSFetchRequest<MovieEntity>{
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
         
         
         
    }
    
}
