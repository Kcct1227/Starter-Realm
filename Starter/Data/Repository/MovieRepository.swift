//
//  MovieRepository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import RealmSwift

protocol MovieRepository{
    func getDetail(id:Int, completion: @escaping (MovieDetailResponse?) -> Void )
    func saveDetail(data: MovieDetailResponse)
    func saveList(type: MovieSerieGroupType, data: MovieListResult)
    func saveSimilarContent(id: Int, data: [MovieResult])
    func getSimilarContent(id:Int, completion: @escaping ([MovieResult]) -> Void )
    func saveCasts(id: Int, data: [MovieCast])
    func getCasts(id:Int, completion: @escaping ([MovieCast]) -> Void )
}

class MovieRespositoryImpl: BaseRepository, MovieRepository{
    
    
    static let shared : MovieRepository = MovieRespositoryImpl()

    private let contentTypeRepo = ContentTypeRespositoryImpl.shared
    
    private override init() { }
    
//    func saveList(type: MovieSerieGroupType, data: MovieListResult) {
//        let object = BelongsToTypeObject()
//        object.name = type.rawValue
//
//        let moives = List<MovieResultObject>()
//        data.results?.forEach{
//            moives.append(MovieResult.toMovieResultObject(movie: $0))
//
//        }
//        object.movieList = moives
//
//        do{
//            try realmDB.write {
//                realmDB.add(object, update: .modified)
//            }
//        }catch{
//            debugPrint(error.localizedDescription)
//        }
//    }
    
    func saveList(type: MovieSerieGroupType, data : MovieListResult) {
        let objects = List<MovieResultObject>()
        data.results?.map {
            $0.toMovieObject(groupType: contentTypeRepo.getBelongsToTypeObject(type: type))
        }.forEach {
            objects.append($0)
        }
        
        
        try! realmDB.write {
            realmDB.add(objects, update: .modified)
        }
        
        
        
        
    }
    
    
    func getDetail(id: Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        

        
        
        let items:[MovieDetailResponse] = realmDB.objects(MovieResultObject.self)
            .filter("id == %@", id)
            .map{ $0.toMovieDetail() }
        
        completion(items.first)

    }
    
    func getCompanies(id: Int) -> [ProductionCompany] {
        return [ProductionCompany]()
    }
    
    func getCountry(id: Int) -> [ProductionCountry] {
        
        return [ProductionCountry]()
    }
    
    func saveDetail(data: MovieDetailResponse) {
        guard let object  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: data.id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        
        if let cmpList = data.productionCompanies {
           saveCompanies(id: data.id ?? 0, data: cmpList)
        }
    
        if let ctList = data.productionCountries {
            saveCountry(id: data.id ?? 0, data: ctList)
        }

        if let gList = data.genres {
            saveGenreList(id: data.id ?? 0, data: gList)
        }
        
        do{
            try realmDB.write {
                        
                object.budget = data.budget
                object.homepage = data.homepage
                object.status = data.status
                object.imdbID = data.imdbID
                object.tagline = data.tagline
                object.revenue = data.revenue
                object.runtime = data.runtime
                
                    
                realmDB.add(object, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        let similarList = List<MovieResultObject>()
        guard let object  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        
        data.forEach{ movie in
            guard let movieObject  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: movie.id) else{
                debugPrint("Couldnt find object to delete")
                similarList.append(MovieResult.toMovieResultObject(movie: movie))
                return
                
            }
            
            do{
                try realmDB.write{
                    movieObject.adult = movie.adult
                    movieObject.backdropPath = movie.backdropPath
                    movieObject.genreIDS = movie.genreIDS?.map { String($0)}.joined(separator: ",")
                    movieObject.runtime = movie.runtime
                    movieObject.originalLanguage = movie.originalLanguage
                    movieObject.originalTitle = movie.originalTitle
                    movieObject.originalName = movie.originalName
                    movieObject.overview = movie.overview
                    movieObject.popularity = movie.popularity
                    movieObject.posterPath = movie.posterPath
                    movieObject.releaseDate = movie.releaseDate
                    movieObject.firstAirDate  = movie.firstAirDate
                    movieObject.title = movie.title
                    movieObject.video = movie.video
                    movieObject.voteAverage = movie.voteAverage
                    movieObject.voteCount = movie.voteCount
                    
                    similarList.append(movieObject)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                
                
                if similarList.count > 0{
                    object.similarContents = similarList
                    
                }
                realmDB.add(object, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
      
        
        
    }
    
   
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let items:[MovieListResult] = realmDB.objects(MovieResultObject.self)
            .filter("id == %@", id)
            .map{ $0.toSimilarContent() }

        completion(items.first?.results ?? [MovieResult]())
    }
    
    func saveGenreList(id: Int, data: [MovieGenre]) {
        let glist = List<MovieGenreObject>()
        guard let genreObject  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: MovieGenreObject.self, forPrimaryKey: item.id) else{
                debugPrint("Couldnt find object to delete")
                let newObject = MovieGenreObject()
                newObject.id = item.id
                newObject.name = item.name
                glist.append(newObject)
                return
                
            }
            
            do{
                try realmDB.write{
                    
                    //object.id = item.id
                    object.name = item.name
                    glist.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                
                if glist.count > 0{
                    genreObject.genres = glist
                }
                realmDB.add(genreObject, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
      
        
    }
    
    func saveCompanies(id: Int, data: [ProductionCompany]) {
        let companyList = List<ProductionCompanyObject>()
        guard let movieObject  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: ProductionCompanyObject.self, forPrimaryKey: item.id) else{
                debugPrint("Couldnt find object to delete")
                companyList.append(ProductionCompany.toProductionCompanyObject(data: item))
                return
                
            }
            
            do{
                try realmDB.write{
                    
                    //object.id = item.id
                    object.logoPath = item.logoPath
                    object.name = "Testing Testing"
                    object.originCountry = item.originCountry
                    companyList.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                
                if companyList.count > 0{
                    movieObject.productionCompanies = companyList
                }
                realmDB.add(movieObject, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
      
        
    }
    
    func saveCountry(id: Int, data: [ProductionCountry]) {
        let countryList = List<ProductionCountryObject>()
        guard let movieObject  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: ProductionCountryObject.self, forPrimaryKey: item.iso3166_1) else{
                debugPrint("Couldnt find object to delete")
                countryList.append(ProductionCountry.toProductionCountryObject(data: item))
                return
                
            }
            
            do{
                try realmDB.write{
                    object.name = item.name
                    countryList.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                
                if countryList.count > 0{
                    movieObject.productionCountries = countryList
                }
                realmDB.add(movieObject, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void) {
        let items: [MovieResultObject] = realmDB.objects(MovieResultObject.self)
            .filter("id == %@", id)
            .map{ $0 }
        if let data = items.first{
            let creditCastResponse: MovieCreditResponse = data.toMovieCreditResponse()
            completion(creditCastResponse.cast ?? [MovieCast]())
        }
    }
    
    
    
    func saveCasts(id: Int, data: [MovieCast]) {
        let actorList = List<ActorInfoResponseObject>()
        guard let movieObject  = realmDB.object(ofType: MovieResultObject.self, forPrimaryKey: id) else{
            debugPrint("Couldnt find object to delete")
            return
        }
        
        data.forEach{ item in
            let actor = item.convertToActorInfoResponse()
            guard let actorObject  = realmDB.object(ofType: ActorInfoResponseObject.self, forPrimaryKey: actor.id ) else{
                debugPrint("Couldnt find object to delete")
                actorList.append(ActorInfoResponse.toActorDetailResponseObject(data: actor))
                return
                
            }
            
            do{
                try realmDB.write{
                    actorObject.adult = actor.adult
                    actorObject.profilePath = actor.profilePath
                    actorObject.knownForDepartment =  "Acting"
                    actorObject.popularity = actor.popularity
                    actorObject.gender  = actor.gender
                    actorObject.name = actor.name
                    actorList.append(actorObject)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                
                if actorList.count > 0{
                    movieObject.actors = actorList
                }
                realmDB.add(movieObject, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    

}
