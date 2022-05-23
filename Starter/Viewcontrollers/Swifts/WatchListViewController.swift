//
//  WatchListViewController.swift
//  Starter
//
//  Created by KC on 06/05/2022.
//

import Foundation
import UIKit

class WatchListViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    
    private let numberOfItemsPerRow = 3
    private let itemSpacing : CGFloat = 10
    
    private let watchListModel : WatchListModel = WatchListModelImpl.shared
    private var data = [MovieResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        initData()
    }
    
    func initView() {
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        collectionView.backgroundColor = UIColor(named: "color_primary")
        collectionView.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)

        collectionView.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
    }

    private func initData() {
       watchListModel.initFetchResultController(subscription: self)
    }
    
    deinit {
        
        watchListModel.deinitFetchResultController()
    }
    
   
}

extension WatchListViewController: WatchListRepoSubscription {
    func onFetchResultDidChange(didChange objects: [MovieResult]) {
        self.data = objects
        self.collectionView.reloadData()
    }
}


//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension WatchListViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else { return UICollectionViewCell() }
        cell.data = data[indexPath.row]
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WatchListViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing : CGFloat = (itemSpacing * CGFloat(numberOfItemsPerRow - 1)) + collectionView.contentInset.left + collectionView.contentInset.right
        
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(numberOfItemsPerRow)) - (totalSpacing / CGFloat(numberOfItemsPerRow))
        let itemHeight : CGFloat = 250
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item  =  data[indexPath.row]
        navigateToMovieDetailViewController(movieId: item.id ?? 0, contentType: item.media_type ?? ContentType.MovieType.rawValue)

    }
    
}
