//
//  RxSearchViewController.swift
//  Starter
//
//  Created by KC on 06/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class RxSearchViewController: UIViewController , UITextFieldDelegate{

    
    @IBOutlet weak var searchMoviesCollectionView: UICollectionView!
    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemsPerRow = 3
    private var currentPage : Int = 1
    private var totalPage : Int = 1
    
    let disposeBag = DisposeBag()
    private let searchBar = UISearchBar()
    
    //MARK: 5 - Behavior Subject List
    let searchResultItems : BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initViews()
        initObservers()
    }

    
    private func initViews(){
        searchBar.placeholder = "Search..."
        searchBar.searchTextField.textColor = .white
        
        navigationItem.titleView = searchBar
        registerViewCell()
        
    }
    
    private func registerViewCell(){
        searchMoviesCollectionView.delegate = self
        //searchMoviesCollectionView.dataSource = self
        searchMoviesCollectionView.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        searchMoviesCollectionView.showsHorizontalScrollIndicator  = false
        searchMoviesCollectionView.showsVerticalScrollIndicator = false
        
        searchMoviesCollectionView.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)

        if let layout = searchMoviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .vertical // .horizontal
        }
    }
    
    private func initObservers() {
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addItemSelectedObserver()
        addPaginationObserver()
    }
    
    //MARK: - API
    private func rxMovieSearch(keyword : String, page : Int) {
        //MARK: - 2
        RxNetworkAgent.shared.searchMovies(query: keyword, page: page)
            .do(onNext: { item in
                self.totalPage = item.totalPages ?? 1
            })
            .compactMap { $0.results }
            .subscribe(onNext: { item in
                if self.currentPage == 1 {
                    self.searchResultItems.onNext(item)
                } else {
                    self.searchResultItems.onNext(try! self.searchResultItems.value() + item)
                }
            })
            .disposed(by: disposeBag)
    }

}

//MARK: - Observers
extension RxSearchViewController {
    
    //MARK: - 1
    private func addSearchBarObserver() {
        // Search Text Field event listener
        searchBar.rx.text.orEmpty
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .do(onNext: { print($0)})
            .subscribe(onNext: { value in
                if value.isEmpty {
                    self.currentPage = 1
                    self.totalPage = 1
                    self.searchResultItems.onNext([])
                } else {
                    self.rxMovieSearch(keyword: value, page: self.currentPage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
    //MARK: - 4
    private func addCollectionViewBindingObserver() {
        // Bind Data to collection view cell
        searchResultItems
            .bind(to: searchMoviesCollectionView.rx.items(
                    cellIdentifier: String(describing: PopularFilmCollectionViewCell.self),
                    cellType: PopularFilmCollectionViewCell.self))
            { row, element, cell in
                cell.data = element
            }
            .disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver() {
        // On Item Selected
        // MARK: - 6
        searchMoviesCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let items = try! self.searchResultItems.value()
                let item = items[indexPath.row]
                self.navigateToMovieDetailViewController(movieId: item.id!, contentType: item.media_type ?? ContentType.MovieType.rawValue)
            })
            .disposed(by: disposeBag)
    }
    
    private func addPaginationObserver() {
        /// Pagination
        // MARK: - 5
        Observable.combineLatest(
            searchMoviesCollectionView.rx.willDisplayCell,
            searchBar.rx.text.orEmpty)
            .subscribe(onNext : { (cellTuple, searchText) in
                let (_, indexPath) = cellTuple
                let totalItems = try! self.searchResultItems.value().count
                let isAtLastRow = indexPath.row == totalItems - 1
                let hasMorePages = self.currentPage < self.totalPage
                if (isAtLastRow && hasMorePages){
                    self.currentPage += 1
                    self.rxMovieSearch(keyword: searchText, page: self.currentPage)
                }
            })
            .disposed(by: disposeBag)
    }
    
}



//MARK: - UICollectionViewDelegateFlowLayout
extension RxSearchViewController:UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing : CGFloat = (itemSpacing * CGFloat(numberOfItemsPerRow - 1)) + collectionView.contentInset.left + searchMoviesCollectionView.contentInset.right
        
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(numberOfItemsPerRow)) - (totalSpacing / CGFloat(numberOfItemsPerRow))
        let itemHeight : CGFloat = itemWidth * 1.8
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }

}

