//
//  ActorRespository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import RealmSwift
import RxSwift

protocol ActorRepository{
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void)
    func getList(page: Int) -> Observable<[ActorInfoResponse]>
    func save(list: [ActorInfoResponse])
    func saveDetials(data: ActorDetailResponse)
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void)
    func getTotalPageActorList(completion: @escaping (Int) -> Void)
    func saveActorCombinedList(id: Int, data: [MovieResult])
    func getActorCombinedList(id:Int, completion: @escaping ([MovieResult]) -> Void )
}

class ActorRepositoryImpl : BaseRepository, ActorRepository{
    
    
    static let shared : ActorRepository = ActorRepositoryImpl()
    private let contentTypeRepo = ContentTypeRespositoryImpl.shared

    
    private override init(){}
    private var pageSize = 20
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void) {
        let items:[ActorInfoResponse] = realmDB.objects(ActorInfoResponseObject.self)
            .sorted(by:({ (first, second) -> Bool in
                return (second.popularity ?? 0.0).isLess(than: first.popularity ?? 0.0)
            }))
            .map{ $0.toActorInfoResponse() }
            
        completion(items)
    }
    
    func saveActorCombinedList(id: Int, data: [MovieResult]) {
        let moives = List<MovieResultObject>()
        guard let actorObject  = realmDB.object(ofType: ActorInfoResponseObject.self, forPrimaryKey: id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        data.forEach{ movie in
            guard let movieObject  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: movie.id) else{
                debugPrint("Couldnt find object to delete")
                if movie.media_type == ContentType.MovieType.rawValue{
                    moives.append(MovieResult.toMovieResultObject(movie: movie))
                }
                return
                
            }
            if movie.media_type == ContentType.MovieType.rawValue{
                do{
                    try realmDB.write{
                        movieObject.adult  = movie.adult
                        movieObject.backdropPath = movie.backdropPath
                        movieObject.genreIDS = movie.genreIDS?.map { String($0)}.joined(separator: ",")
                        movieObject.runtime = movie.runtime
                        movieObject.originalLanguage = movie.originalLanguage
                        movieObject.originalTitle  = movie.originalTitle
                        movieObject.originalName  = movie.originalName
                        movieObject.overview = movie.overview
                        movieObject.popularity = movie.popularity
                        movieObject.posterPath = movie.posterPath
                        movieObject.releaseDate  = movie.releaseDate
                        movieObject.firstAirDate  = movie.firstAirDate
                        movieObject.title = movie.title
                        movieObject.video = movie.video
                        movieObject.voteAverage = movie.voteAverage
                        movieObject.voteCount = movie.voteCount
                        movieObject.media_type = movie.media_type
                        moives.append(movieObject)
                    }
                }catch{
                    debugPrint(error.localizedDescription)
                }
            }
            
            
        }
        
        do{
            try realmDB.write {
                actorObject.knownFor = moives
                realmDB.add(actorObject, update: .all)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
       
        
    }
    
    func getList(page: Int) -> Observable<[ActorInfoResponse]> {
        let realmObjects = realmDB.objects(ActorInfoResponseObject.self)
            .sorted(byKeyPath: "popularity", ascending: false)
            //.sorted(byKeyPath: "name", ascending: true)
        
         return Observable.collection(from:realmObjects)
            .flatMap { (results) -> Observable<[ActorInfoResponseObject]> in
                .just(results.toArray())
            }
            .flatMap { (objects) -> Observable<[ActorInfoResponse]> in
                .just(objects.map { $0.toActorInfoResponse() })
            }

    }
    
    

    func getActorCombinedList(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let items:[ActorInfoResponse] = realmDB.objects(ActorInfoResponseObject.self)
            .filter("id == %@", id)
            .map{ $0.toActorInfoResponse() }

        completion(items.first?.knownFor ?? [MovieResult]())
    }
    
    
    func save(list: [ActorInfoResponse]) {
        
        list.forEach{ data in
            var object = ActorInfoResponseObject()
            object = ActorInfoResponse.toActorDetailResponseObject(data: data)
            
            do{
                try realmDB.write {
                    realmDB.add(object, update: .modified)
                }
                //success()
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func saveDetials(data: ActorDetailResponse) {
        guard let object  = realmDB.object(ofType: ActorInfoResponseObject.self, forPrimaryKey: data.id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        do{
            try realmDB.write {
                object.homepage = data.homepage
                object.birthday = data.birthday
                object.biography = data.biography
                object.imdbID = data.imdbID
                
                realmDB.add(object, update: .all)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void) {
        let items:[ActorDetailResponse] = realmDB.objects(ActorInfoResponseObject.self)
            .filter("id == %@", id)
            .map{ $0.toActorDetailResponse() }

        completion(items.first)

    }
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void) {
        let items:[ActorDetailResponse] = realmDB.objects(ActorInfoResponseObject.self)
            .map{ $0.toActorDetailResponse() }
        completion(items.count / pageSize)
    }
}
