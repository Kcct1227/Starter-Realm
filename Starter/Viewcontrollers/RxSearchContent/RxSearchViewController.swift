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
    private let searchBar = UISearchBar()
    
    var viewModel: RxSearchContentVCViewModel!
    let disposeBag = DisposeBag()
    
    //MARK: 5 - Behavior Subject List

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RxSearchContentVCViewModel()

        // Do any additional setup after loading the view.
        initViews()
        bindData()
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
    
    private func bindData() {
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addItemSelectedObserver()
        addPaginationObserver()
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
                self.viewModel.handleSearchInputText(text: value)
            })
            .disposed(by: disposeBag)
    }
    
    
    
    //MARK: - 4
    private func addCollectionViewBindingObserver() {
        // Bind Data to collection view cell
        viewModel.searchResultItems
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
                let items = try! self.viewModel.searchResultItems.value()
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
                self.viewModel.handlePaganation(index: indexPath, searchText: searchText)
            })
            .disposed(by: disposeBag)
    }
    
}



//MARK: - UICollectionViewDelegateFlowLayout
extension RxSearchViewController:UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing : CGFloat = (viewModel.itemSpacing * CGFloat(viewModel.numberOfItemsPerRow - 1)) + collectionView.contentInset.left + searchMoviesCollectionView.contentInset.right
        
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(viewModel.numberOfItemsPerRow)) - (totalSpacing / CGFloat(viewModel.numberOfItemsPerRow))
        let itemHeight : CGFloat = itemWidth * 1.8
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.itemSpacing
    }

}

