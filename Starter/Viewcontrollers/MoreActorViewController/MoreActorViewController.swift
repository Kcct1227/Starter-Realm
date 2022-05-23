//
//  MoreActorViewController.swift
//  Starter
//
//  Created by KC on 16/03/2022.
//

import UIKit

class MoreActorViewController: UIViewController, ActorActionDelegate {
    
    @IBOutlet weak var collectionViewActors : UICollectionView!
    var delegate: ActorActionDelegate?=nil

    var initData  : [ActorInfoResponse]?
    private let actorModel : ActorModel = ActorModelImpl.shared
    private var data : [ActorInfoResponse] = []
    private let numberOfItemsPerRow = 3
    private var totalPages : Int = 1
    private var currentPage: Int = 1
    private let itemSpacing : CGFloat = 10


    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        //initState()
        fetchPopularPeople(page: currentPage)

    }
    
    private func initState(){
        
    }
    
    private func initView(){
        setUpCollectionView()
    }
    
    private func setUpCollectionView(){
        collectionViewActors.delegate = self
        collectionViewActors.dataSource = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
        collectionViewActors.showsHorizontalScrollIndicator  = false
        collectionViewActors.showsVerticalScrollIndicator = false
        collectionViewActors.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)

        if let layout = collectionViewActors.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .vertical // .horizontal
        }
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let width = UIScreen.main.bounds.width
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        layout.itemSize = CGSize(width: width / 2, height: width / 2)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        collectionViewActors!.collectionViewLayout = layout
        
    
    }
    
    func fetchPopularPeople(page: Int){
        actorModel.getPopularPeople(page: page){ [weak self](result) in
            guard let self = self else { return }
            switch result{
            case .success(let resultData):
                self.data.append(contentsOf: resultData.results ?? [ActorInfoResponse]())
                //  UI update
                self.totalPages = self.actorModel.totalPageActorList
                self.collectionViewActors.reloadData()
            case .failure(let message):
                print(message)
            }
        }
    }
    
    
    func onTapFavorite(isFavorite: Bool) {
        
    }
    
}

extension MoreActorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: ActorCollectionViewCell.identifier, indexPath: indexPath) as ActorCollectionViewCell
        cell.delegate = self
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing : CGFloat = (itemSpacing * CGFloat(numberOfItemsPerRow - 1)) + collectionView.contentInset.left + collectionViewActors.contentInset.right
        
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(numberOfItemsPerRow)) - (totalSpacing / CGFloat(numberOfItemsPerRow))
        let itemHeight : CGFloat = itemWidth * 1.5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item  = self.data[indexPath.row]
        navigateToMovieDetailViewController(movieId: item.id ?? 0, contentType: ContentType.ActorType.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == (data.count - 1)
        let haveMorePage = currentPage < totalPages //  9, 10 => page 10 => fetchData(page 10)
        if isAtLastRow && haveMorePage{
            currentPage = currentPage + 1
            fetchPopularPeople(page: currentPage)
        }
    }
    
    
}
