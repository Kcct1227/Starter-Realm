//
//  GenreRepository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import CoreData

protocol GenreRepository{
    func get(completion: @escaping (MovieGenreList) -> Void )
    func save(data: MovieGenreList)
}

class GenreRepositoryImpl : BaseRepository, GenreRepository{
    
    static let shared : GenreRepository = GenreRepositoryImpl()
        
    private override init(){}
    
    func get(completion: @escaping (MovieGenreList) -> Void) {
        let fetchRequest : NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        do{
            let results : [GenreEntity] = try coreData.context.fetch(fetchRequest)
            let items = results.map {
                GenreEntity.toMovieGenre(entity: $0)
            }
            
            completion(MovieGenreList(genres: items))
        }catch{
            completion(MovieGenreList(genres: [MovieGenre]()))
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func save(data: MovieGenreList) {
        let _ = data.genres.map{
            let entity = GenreEntity(context: coreData.context)
            entity.id = String($0.id)
            entity.name = $0.name
            return
        }
        coreData.saveContext()
    }
}
