//
//  MovieViewController.swift
//  Starter
//
//  Created by KC on 09/02/2022.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import CloudKit

class MovieViewController: UIViewController, MovieItemDelegate, MoreActorDelegae, MoreShowCaseDelegate{
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewForToolbar: UIView!
    @IBOutlet weak var tableViewMovies: UITableView!
    
    //MARK: - Property
    private let movieModel          = MovieModelImpl.shared
    private let seriesModel : SeriesModel = SeriesModelImpl.shared
    private let actorModel : ActorModel = ActorModelImpl.shared
    private let detailModel: DetailModel = DetailModelImpl.shared
    //private let networkingAgent = MovieDBNetworkAgentWithURLSession.shared
    //private let networkingAgent = MovieDBNetworkAgent.shared
    
    private var upComingMovieList: [MovieResult]?
    private var popularMovieList: [MovieResult]?
    private var popularSeriesList: [MovieResult]?
    private var genresList: [MovieGenre]?
    private var topRatedMovieList : [MovieResult]?
    private var popularPeople : [ActorInfoResponse]?
    
    private let disposeBag = DisposeBag()
    
    private var observablePopularMovies     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableTopRatedMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableUpcomingMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableActorList         = BehaviorRelay<[ActorInfoResponse]>(value:[])
    private var observablePopularSeries     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableGenreList         = BehaviorRelay<[MovieGenre]>(value:[])
    
    
    private let rxmovieModel        = RxMovieModelImpl.shared
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initObservable()
        initObservers()
        fetchData()

    }
    
    private func initObservers() {
        Observable.combineLatest(
            observableGenreList,
            observableTopRatedMovies,
            observablePopularMovies,
            observablePopularSeries,
            observableUpcomingMovies,
            observableActorList
        )
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .flatMap { (
            genreList,
            topRatedMovies,
            popularMovies,
            popularSeries,
            upcomingMovies,
            actorList) -> Observable<[HomeMovieSectionModel]> in
            var items = [HomeMovieSectionModel]()
            if !upcomingMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.upcomingMoviesSection(items: upcomingMovies)]))
            }
            
            if !popularMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularMoviesSection(items: popularMovies)]))
            }
            
            if !popularSeries.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularSeriesSection(items: popularSeries)]))
            }
            
            items.append(HomeMovieSectionModel.others(items: [.movieShowTimeSection]))
            
            if !genreList.isEmpty {
                items.append(HomeMovieSectionModel.genreResult(items: [.movieGenreSection(genres: genreList, movies: upcomingMovies + popularMovies + popularSeries)]))
            }
            
            if !topRatedMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.showcaseMoviesSection(items: topRatedMovies)]))
            }
            
            if !actorList.isEmpty {
                items.append(HomeMovieSectionModel.actorResult(items: [.bestActorSection(items: actorList)]))
            }
            return .just(items)
        }.bind(to: tableViewMovies.rx.items(dataSource: initDataSource()))
        .disposed(by: disposeBag)
        
        
    }
    
    private func initObservable() {
        rxmovieModel.getPopularMovieList()
            .subscribe(onNext: { self.observablePopularMovies.accept($0) })
            .disposed(by: disposeBag)
        
        rxmovieModel.getPopularSeriesList()
            .subscribe(onNext: { items in
                self.observablePopularSeries.accept(items)
            })
            .disposed(by: disposeBag)

        rxmovieModel.getTopRatedMovieList(page: 1)
            .subscribe(onNext: { self.observableTopRatedMovies.accept($0) })
            .disposed(by: disposeBag)

        rxmovieModel.getUpcomingMovieList()
            .subscribe(onNext: { self.observableUpcomingMovies.accept($0) })
            .disposed(by: disposeBag)

        actorModel.getPopularPeople(page: 1)
            .subscribe(onNext: { self.observableActorList.accept($0) })
            .disposed(by: disposeBag)

        rxmovieModel.getGenreList()
            .subscribe(onNext: { self.observableGenreList.accept($0) })
            .disposed(by: disposeBag)
    }
    
    //MARK: Init View
    private func initView(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
        
      
        registerTableViewCell()

    }
    
    private func fetchData(){
        initObservable()
    }
    
    
    
    private func registerTableViewCell(){
        //tableViewMovies.dataSource = self
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: GenereTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
    @IBAction func onClickSearch( _ sender: UIBarButtonItem){
        navigateToSearchContentViewController()
        
    }

    
   
    //MARK: Tap Item
    func onTapMoreShowCases(data: [MovieResult]) {
        navigateToMoreShowCaseViewController(data: data)
    }

    func onTapMoreActor(data: [ActorInfoResponse]) {
        
        navigateToMoreActorsViewController(data: data)
    }

    
    func onTapMovie(id: Int, type: String){
        navigateToMovieDetailViewController(movieId: id, contentType: type)

    }
 
}


    

