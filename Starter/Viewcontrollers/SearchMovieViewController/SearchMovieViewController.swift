//
//  SearchMovieViewController.swift
//  Starter
//
//  Created by KC on 17/03/2022.
//

import UIKit

class SearchMovieViewController: UIViewController {
    

    @IBOutlet weak var searchMoviesCollectionView : UICollectionView!
    @IBOutlet weak var stackNoData : UIStackView!
    
    private let searchBar = UISearchBar()
    private let searchMovieModel : SearchMovieModel = SearchMovieModelImpl.shared
    private var data : [MovieResult] = []
    private let numberOfItemsPerRow = 3
    private var totalPages : Int = 1
    private var currentPage: Int = 1
    private let itemSpacing : CGFloat = 10
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()

    }
    
    

    private func initView(){
        searchBar.placeholder = "Search...."
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        navigationItem.titleView = searchBar
        registerViewCell()
        stackNoData.isHidden = true
        
    }
    
    private func registerViewCell(){
        searchMoviesCollectionView.delegate = self
        searchMoviesCollectionView.dataSource = self
        searchMoviesCollectionView.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        searchMoviesCollectionView.showsHorizontalScrollIndicator  = false
        searchMoviesCollectionView.showsVerticalScrollIndicator = false
        
        searchMoviesCollectionView.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)

        if let layout = searchMoviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .vertical // .horizontal
        }
    }

    func fetchSearchMovie(name: String, page: Int){
        searchMovieModel.getSearchMovie(name: name, page: page){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let resultData):
                let data = resultData.results?.filter { result in
                    result.media_type ?? ""  == ContentType.MovieType.rawValue || result.media_type ?? "" == ContentType.SerieType.rawValue
                }
                if data?.count == 0{
                    self.stackNoData.isHidden = false
                    self.searchMoviesCollectionView.isHidden = true
                }
                else{
                    
                    self.data.append(contentsOf: data ?? [MovieResult]())
                    //  UI update
                    self.totalPages = resultData.totalPages ?? 1
                    self.searchMoviesCollectionView.reloadData()
                    self.stackNoData.isHidden = true
                    self.searchMoviesCollectionView.isHidden = false
                }
           
                
            case .failure(let message):
                print(message)
            
            }
        }
    }
   
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension SearchMovieViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: MovieResult = data[indexPath.row]
        navigateToMovieDetailViewController(movieId: item.id ?? 0 , contentType: item.media_type ??  ContentType.MovieType.rawValue )
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == (data.count - 1)
        let haveMorePage = currentPage < totalPages //  9, 10 => page 10 => fetchData(page 10)
        if isAtLastRow && haveMorePage{
            currentPage = currentPage + 1
            fetchSearchMovie(name: searchBar.text ?? "", page: currentPage)
        }
    }
    
    
}

extension SearchMovieViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let text = searchBar.text {
            if !text.isEmpty{
                self.currentPage = 1
                self.totalPages = 1
                self.data.removeAll()
                fetchSearchMovie(name: text, page: currentPage)
            }
            
        }
    }
   
}


extension SearchMovieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        if let text = textFieldSearch.text{
//            currentPage = 1
//            data.removeAll()
//            fetchSearchMovie(name: text , page: currentPage)
//        }
        return true
    }
}

