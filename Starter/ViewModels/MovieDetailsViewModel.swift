//
//  MovieDetailsViewModel.swift
//  Starter
//
//  Created by KC on 20/05/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Combine


enum ArtistDeatilViewState{
    case addedBookMark
    case removeBookMark
    case bindActorData(data: ActorDetailResponse)
    case bindMovieData(data:MovieDetailResponse)
    case bindSeriesData(data: SeriesDetailResponse)
}

class MovieDetailsViewModel : MovieDetailViewModelType{
  
    //MARK: - Property
    var movieID : Int = -1
    var type: String = ""
    var url = ""
    
    var productionCompanies : [ProductionCompany] = []
    var movieTrailers : [MovieTrailer] = []
    var movieCasts : BehaviorSubject<[MovieCast]> = BehaviorSubject(value: [])
    var similarMovies : BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    var viewState: PassthroughSubject<ArtistDeatilViewState, Never> = .init()

    
    
    // Models
    private let movieModel : MovieModel = MovieModelImpl.shared
    private let seriesModel : SeriesModel = SeriesModelImpl.shared
    private let actorModel : ActorModel = ActorModelImpl.shared
    private let watchListModel : WatchListModel = WatchListModelImpl.shared
    
    private let detailModel: DetailModel = DetailModelImpl.shared
    private let rxmovieModel        = RxMovieModelImpl.shared
    
    private let disposeBag = DisposeBag()
    
    init(){
       
    }
    
    func setupData(){
        initData()
        checkType()
        checkWatchList()

    }
    
    private func initData() {
        if type == ContentType.MovieType.rawValue{

            detailModel.initFetchResultController(id: self.movieID)

            detailModel.getSimilarMoviesObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.similarMovies.onNext(data)
                }).disposed(by: disposeBag)

            detailModel.getMovieDetailObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.viewState.send(.bindMovieData(data: data))
                }).disposed(by: disposeBag)

            detailModel.getMovieCastObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.movieCasts.onNext(data)
                }).disposed(by: disposeBag)
        }
        else if type == ContentType.SerieType.rawValue{
            detailModel.initSeriesFetchResultController(id: self.movieID)

            detailModel.getSimilarSeriesObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.similarMovies.onNext(data)
                }).disposed(by: disposeBag)

            detailModel.getSeriesDetailObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.viewState.send(.bindSeriesData(data: data.toSeriesDetailResonse()))
                }).disposed(by: disposeBag)

            detailModel.getSeriesCastObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.movieCasts.onNext(data)
                }).disposed(by: disposeBag)
        }
        else{
            
            detailModel.initActorFetchResultController(id: self.movieID)

            detailModel.getActorMovieContentObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.similarMovies.onNext(data)
                }).disposed(by: disposeBag)

            detailModel.getActorDetailObservable()
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    //self.bindActorData(data: data)
                    self.viewState.send(.bindActorData(data: data))
                }).disposed(by: disposeBag)


        }
        
    }
    
    private func checkType(){
        
        switch(type){
        case ContentType.MovieType.rawValue:
            setUpMovie()
            break
        case ContentType.SerieType.rawValue:
            setUpSeries()
            break
        case ContentType.ActorType.rawValue:
            setUpActors()
        default:
            print("")
        }
    }
    
    private func setUpActors(){
        fetchActorCombinedListObservable()
        
    }
    
    private func setUpSeries(){
        fetchSeriesTrailer(id: movieID)
        fetchSeriesCastObservable()
        fetchSimlarSeriesObservable()
    }
        
    private func setUpMovie(){
        fetchMovieTrailer(id: movieID)
        fetchMovieCastObservable()
        fetchSimlarMovieObservable()
    
    }
    
    private func fetchSeriesTrailer(id: Int){
        seriesModel.getSeriesTrailerVideo(id: id) { (result) in
            switch result{
            case .success(let data):
                self.movieTrailers = data.results ?? [MovieTrailer] ()
            case .failure(let message):
                print(message)
            }
        }
    }
    
    
    private func fetchMovieTrailer(id: Int){
        movieModel.getMovieTrailerVideo(id: id) { (result) in
            switch result{
            case .success(let data):
                self.movieTrailers = data.results ?? [MovieTrailer] ()
               
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fetchActorCombinedListObservable(){
        rxmovieModel.getActorCombinedListById(id: movieID)
            .subscribe(onNext: { [weak self] (data) in
                guard let self = self else { return }
                self.similarMovies.onNext(data)
            })
            .disposed(by: disposeBag)

    }
    
    // MARK: - Movie Cast Observable
    private func fetchMovieCastObservable(){
        rxmovieModel.getMovieCreditByid(id: movieID)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.movieCasts.onNext(data)
            })
            .disposed(by: disposeBag)
    }
    


    
    private func fetchSimlarSeriesObservable(){

        rxmovieModel.getSimilarSeriesById(id: movieID)
            .subscribe(onNext: { [weak self] (data) in
                guard let self = self else { return }
                self.similarMovies.onNext(data)
            })
            .disposed(by: disposeBag)

    }
    
    private func fetchSimlarMovieObservable(){

        rxmovieModel.getSimilarMovieById(id: movieID)
            .subscribe(onNext: { [weak self] (data) in
                guard let self = self else { return }
                self.similarMovies.onNext(data)
            })
            .disposed(by: disposeBag)

    }

    private func fetchSeriesCastObservable(){
        rxmovieModel.getSeriesCreditById(id: movieID)
            .subscribe(onNext: { [weak self] (data) in
                guard let self = self else { return }
                self.movieCasts.onNext(data)
            })
            .disposed(by: disposeBag)
    }
    
    func deinitFetchController() {
        if type == ContentType.MovieType.rawValue{
            detailModel.deinitMovieResultController()
        }
        else if type == ContentType.SerieType.rawValue{
            detailModel.deinitSeriesResultController()
        }
        else{
            detailModel.deinitActorResultController()
        }

    }
    
    var isWatched: Bool = false {
        didSet {
            if isWatched {
                viewState.send(.addedBookMark)
            } else {
                viewState.send(.removeBookMark)
            }
        }
    }
    
    func checkWatchList(){
        watchListModel.checkMovieId(id: self.movieID) { (data) in
            self.isWatched = data
        }
    }
    
   
    
    func toggleWatched(){
        if self.isWatched {
            watchListModel.removeMovie(id: self.movieID, completion: nil)
        } else {
            watchListModel.saveWatchMovieId(id: self.movieID, completion: nil)
        }
        
        self.isWatched.toggle()
    }
    
    func fetchDetails(){
        if type == ContentType.MovieType.rawValue{
            detailModel.saveMovieDetailObservable(id: self.movieID)
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.viewState.send(.bindMovieData(data: data))

                })
                .disposed(by: disposeBag)
        }
        else if type == ContentType.SerieType.rawValue{
            detailModel.saveSeriesDetailObservable(id: self.movieID)
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.viewState.send(.bindSeriesData(data: data.toSeriesDetailResonse()))

                })
                .disposed(by: disposeBag)        }
        else{
            detailModel.saveActorDetailObservable(id: self.movieID)
                .subscribe(onNext: { [weak self] data in
                    guard let self = self else { return }
                    self.viewState.send(.bindActorData(data: data))

                })
                .disposed(by: disposeBag)
        }
        

    }
}
