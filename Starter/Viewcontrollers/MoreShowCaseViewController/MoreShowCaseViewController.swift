//
//  MoreShowCaseViewController.swift
//  Starter
//
//  Created by KC on 17/03/2022.
//

import UIKit

class MoreShowCaseViewController: UIViewController {
    
    @IBOutlet weak var moreshowcaseCollection: UICollectionView!
    
    var initData  : [MovieResult]?
    private let movieModel : MovieModel = MovieModelImpl.shared
    private let networkAgent = MovieDBNetworkAgent.shared
    private var data : [MovieResult] = []
    private let numberOfItemsPerRow = 3
    private var totalPages : Int = 1
    private var currentPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
       // initState()
        fetchMoreShowCases(page: currentPage)
        
    }

    private func initState(){
        
       // currentPage =  1
       // totalPages =  1
        
       // data.append(contentsOf: initData ?? [MovieResult]())
        moreshowcaseCollection.reloadData()
    }
    
    private func initView(){
        setUpCollectionView()

    }
    
    private func setUpCollectionView(){
        moreshowcaseCollection.delegate = self
        moreshowcaseCollection.dataSource = self
        moreshowcaseCollection.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
        moreshowcaseCollection.showsHorizontalScrollIndicator  = false
        moreshowcaseCollection.showsVerticalScrollIndicator = false
        
    
    }
    
    func fetchMoreShowCases(page: Int){
        networkAgent.getTopRatedMovieList(page: page){ [weak self](result) in
            guard let self = self else { return }
            switch result{
            case .success(let resultData):
                self.data.append(contentsOf: resultData.results ?? [MovieResult]())
                //  UI update
                self.currentPage =  resultData.page ?? 1
                self.totalPages = resultData.totalPages ?? 1
                self.moreshowcaseCollection.reloadData()
            case .failure(let message):
                print(message)
            }
        }
    }
}

extension MoreShowCaseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as ShowCaseCollectionViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemWidth: CGFloat = collectionView.frame.width
        let itemHeight: CGFloat = (itemWidth / 16) * 9
                
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: MovieResult = data[indexPath.row]
        navigateToMovieDetailViewController(movieId: item.id ?? 0 , contentType: item.media_type ??  ContentType.MovieType.rawValue )
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == (data.count - 1)
        let haveMorePage = currentPage < totalPages //  9, 10 => page 10 => fetchData(page 10)
        if isAtLastRow && haveMorePage{
            currentPage = currentPage + 1
            fetchMoreShowCases(page: currentPage)
        }
    }
    
    
}
