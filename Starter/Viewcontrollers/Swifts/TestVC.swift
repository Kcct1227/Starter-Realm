//
//  TestVC.swift
//  Starter
//
//  Created by KC on 09/02/2022.
//

import UIKit
import RxSwift

class TestVC: UIViewController, MovieItemDelegate, MoreActorDelegae, MoreShowCaseDelegate{
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewForToolbar: UIView!
    @IBOutlet weak var tableViewMovies: UITableView!
    
    //MARK: - Property
    private let rxmovieModel : RxMovieModel = RxMovieModelImpl.shared
    private let seriesModel : SeriesModel = SeriesModelImpl.shared
    private let actorModel : ActorModel = ActorModelImpl.shared
    //private let networkingAgent = MovieDBNetworkAgentWithURLSession.shared
    //private let networkingAgent = MovieDBNetworkAgent.shared
    
    private var upComingMovieList: [MovieResult]?
    private var popularMovieList: [MovieResult]?
    private var popularSeriesList: [MovieResult]?
    private var genresList: [MovieGenre]?
    private var topRatedMovieList : [MovieResult]?
    private var popularPeople : [ActorInfoResponse]?
    
    private let disposeBag = DisposeBag()

    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    //MARK: Init View
    private func initView(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
        fetchTopRatedMovieList()
        fetchUpComingMovieList()
        fetchUpPopularMovieList()
        fetchUpPopularSeriesList()
        fetchMovieGenreList()
        fetchPopularPeople()
        registerTableViewCell()
       // movieModel.testing()

    }
    
    private func registerTableViewCell(){
        tableViewMovies.dataSource = self
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
    
    //MARK: - API Call
    func fetchTopRatedMovieList(){
        rxmovieModel.getTopRatedMovieList(page: 1)
            .subscribe { (data) in
                self.topRatedMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_SHOWCASE.rawValue), with: .automatic)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchMovieGenreList(){
        rxmovieModel.getGenreList()
            .subscribe { (data) in
                self.genresList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_GENRE.rawValue), with: .automatic)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
//        movieModel.getGenreList { [weak self] (result) in
//            guard let self = self else { return }
//            switch result{
//            case .success(let data):
//                self.genresList = data
//                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_GENRE.rawValue), with: .automatic)
//            case .failure(let message):
//                print(message)
//            }
//        }
    }
    
    func fetchUpComingMovieList(){
//        movieModel.getUpComingMovieList{ [weak self] (result) in
//            guard let self = self else { return }
//            switch result{
//            case .success(let data):
//                self.upComingMovieList = data
//                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue), with: .automatic)
//            case .failure(let message):
//                print(message)
//            }
//        }
        rxmovieModel.getUpcomingMovieList()
            .subscribe { (data) in
                self.upComingMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue), with: .automatic)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchUpPopularMovieList(){
        rxmovieModel.getPopularMovieList()
            .subscribe { (data) in
                self.popularMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
//        movieModel.getPopularMovieList(page: 1){ [weak self] (result) in
//            guard let self = self else { return }
//            switch result{
//            case .success(let data):
//                self.popularMovieList = data
//                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
//            case .failure(let message):
//                print(message)
//            }
//        }
    }

    func fetchPopularPeople(){
        actorModel.getPopularPeople(page: 1){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.popularPeople = data
                //  UI update
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_BEST_ACTOR.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
            }
        }
    }
    
    func fetchUpPopularSeriesList(){
        rxmovieModel.getPopularSeriesList()
            .subscribe { (data) in
                self.popularSeriesList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.SERIES_POPULAR.rawValue), with: .automatic)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
//        seriesModel.getPopularSeriesList{ [weak self] (result) in
//            guard let self = self else { return }
//            switch result{
//            case .success(let data):
//                self.popularSeriesList = data
//                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.SERIES_POPULAR.rawValue), with: .automatic)
//            case .failure(let message):
//                print(message)
//            }
//        }
    }
    
}

//MARK: - UITableViewDataSource
extension TestVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(indexPath.section){
        case MovieType.MOVIE_SLIDER.rawValue:
            let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
            cell.delegate = self
            cell.contentType = ContentType.MovieType.rawValue
            cell.data = upComingMovieList
            return cell
        case MovieType.MOVIE_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.delegate = self
            cell.contentType = ContentType.MovieType.rawValue
            cell.labelTitle.text = "popular movies".uppercased()
            cell.data = popularMovieList
            return cell
            
        case MovieType.SERIES_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.delegate = self
            cell.contentType = ContentType.SerieType.rawValue
            cell.labelTitle.text = "popular series".uppercased()
            cell.data = popularSeriesList
            return cell
        case MovieType.MOVIE_SHOWTIME.rawValue:
            return tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
        case MovieType.MOVIE_GENRE.rawValue:
            let cell = tableView.dequeueCell(identifier: GenereTableViewCell.identifier, indexPath: indexPath) as GenereTableViewCell
            cell.delegate = self
           
            // binding movie list
            var movieList : [MovieResult] = []
            movieList.append(contentsOf: upComingMovieList ?? [MovieResult]())
            movieList.append(contentsOf: popularSeriesList ?? [MovieResult]())
            movieList.append(contentsOf: popularMovieList ?? [MovieResult]())
            cell.allMoviesAndSeries = movieList
            
            // binding genre list
            let resultData : [GenreVO]? = genresList?.map{ movieGenre -> GenreVO in
                return movieGenre.converToGenreVO()
            }
            resultData?.first?.isSelected = true
            cell.genreList = resultData
            cell.contentType = ContentType.MovieType.rawValue
            
            return cell
        case MovieType.MOVIE_SHOWCASE.rawValue:
            let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
            cell.delegate = self
            cell.data = topRatedMovieList
            cell.contentType = ContentType.MovieType.rawValue
            cell.moreShowCaseDelegate = self
            return cell
        case MovieType.MOVIE_BEST_ACTOR.rawValue:
            let cell =  tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
            cell.delegate = self
            cell.data = popularPeople
            cell.contentType = ContentType.ActorType.rawValue
            cell.moreActorDelegate = self
            return cell
        default:
            return UITableViewCell()
            
        }
        
       
    }
    
    
}
