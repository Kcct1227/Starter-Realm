//
//  BestActorTableViewCell.swift
//  Starter
//
//  Created by KC on 11/02/2022.
//

import UIKit

class BestActorTableViewCell: UITableViewCell, ActorActionDelegate {
   
    

    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var lblMoreActors: UILabel!
    @IBOutlet weak var lblBestActors: UILabel!
    
    var contentType: String = ""
    weak var delegate : MovieItemDelegate?=nil
    
    weak var moreActorDelegate : MoreActorDelegae? = nil
    
    var data: [ActorInfoResponse]?{
        didSet{
            if let _ = data{
                lblMoreActors.isUserInteractionEnabled = true
                collectionViewActors.reloadData()
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblMoreActors.underLineText(text: "MORE ACTORS")
        lblMoreActors.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapMore)))
        registerCollectionViewCell()
    }
    
    
    @objc func onTapMore(){
        moreActorDelegate?.onTapMoreActor(data: data!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTapFavorite(isFavorite: Bool) {
        debugPrint("isFavorite => \(isFavorite)")
    }
    
    private func registerCollectionViewCell(){
        collectionViewActors.delegate = self
        collectionViewActors.dataSource = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
        
    
    }
    
    
    
}

extension BestActorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: ActorCollectionViewCell.identifier, indexPath: indexPath) as ActorCollectionViewCell
        cell.delegate = self
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth : CGFloat = 120
        let itemHeight : CGFloat = itemWidth * 1.5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item  = self.data?[indexPath.row]
        delegate?.onTapMovie(id: item?.id ?? 0, type: contentType)
    }
    
    
}
