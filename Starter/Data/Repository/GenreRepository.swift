//
//  GenreRepository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol GenreRepository{
    func get(completion: @escaping (MovieGenreList) -> Void )
    func save(data: MovieGenreList)
    func get() -> Observable<[MovieGenre]> 
}

class GenreRepositoryImpl : BaseRepository, GenreRepository{
    
    static let shared : GenreRepository = GenreRepositoryImpl()
        
    private override init(){}
    
    func get(completion: @escaping (MovieGenreList) -> Void) {
        
        
        let items:[MovieGenre] = realmDB.objects(MovieGenreObject.self)
            .map{ $0.toMovieGenre() }
            .sorted(by:({ (first, second) -> Bool in
                return first.name.caseInsensitiveCompare(second.name) == .orderedAscending
            }))

        completion(MovieGenreList(genres: items))
    }
    
    func get() -> Observable<[MovieGenre]> {
        let realmObject = realmDB.objects(MovieGenreObject.self)
            .sorted(byKeyPath: "name", ascending: true)
        
        let observable = Observable.collection(from: realmObject)
            .flatMap { (results) -> Observable<[MovieGenreObject]> in
                .just(results.toArray())
            }
            .flatMap { (objects) -> Observable<[MovieGenre]> in
                .just(objects.map { $0.toMovieGenre() })
            }
        
        return observable
    }
    
    
    func save(data: MovieGenreList) {
        let _ = data.genres.map{
            let object = MovieGenreObject()
            object.name = $0.name
            object.id = $0.id
            
            do{
                try realmDB.write{
                    realmDB.add(object, update: .modified)
                }
            }catch{
                debugPrint(error.localizedDescription)

            }
        }
    }
}
