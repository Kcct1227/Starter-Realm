//
//  PopularFilmTableViewCell.swift
//  Starter
//
//  Created by KC on 10/02/2022.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionViewMovies: UICollectionView!
    
    weak var delegate: MovieItemDelegate?=nil
    
    var contentType: String = ""

    var data : [MovieResult]?{
        didSet{
            if let _ = data {
                collectionViewMovies.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func registerCollectionViewCell(){
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        collectionViewMovies.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
}

extension PopularFilmTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
        
        cell.data = data?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = 120
        let itemHeight : CGFloat = collectionView.frame.height

        return CGSize(width: itemWidth, height: itemHeight)
        
        
//        let itemWidth : CGFloat = collectionView.frame.width / 3
//        let itemHeight : CGFloat = collectionView.frame.height
//        return CGSize(width: itemWidth, height: itemHeight)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item  =  data?[indexPath.row]
        delegate?.onTapMovie(id: item?.id ?? 0, type: contentType)
    }
    
    
}
