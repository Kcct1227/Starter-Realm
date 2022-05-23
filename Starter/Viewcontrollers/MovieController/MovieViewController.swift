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
    private let disposeBag = DisposeBag()

    var viewModel: MovieViewModel!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieViewModel()
        
        initView()
        bindData()
        viewModel.fetchAllData()

    }
    
    private func bindData(){
        viewModel.homeItemList
            .bind(to: tableViewMovies.rx.items(dataSource: initDataSource()))
            .disposed(by: disposeBag)
    }
    
    //MARK: Init View
    private func initView(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
        registerTableViewCell()
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


    

