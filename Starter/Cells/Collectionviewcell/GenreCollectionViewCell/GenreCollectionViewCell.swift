//
//  GenreCollectionViewCell.swift
//  Starter
//
//  Created by KC on 10/02/2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewForOverlay: UIView!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var onTapItem: ((Int) -> Void) = {_ in}
    
    var data : GenreVO?=nil{
        didSet{
            
            if let genre = data{
                lblGenre.text = genre.name.uppercased()
                (genre.isSelected) ? (viewForOverlay.isHidden = false) : (viewForOverlay.isHidden = true)
                
            }
            
           // lblGenre.text = data?.name
           // (data?.isSelected ?? false) ? (viewForOverlay.isHidden = false) : (viewForOverlay.isHidden = true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureForContainer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGestureForContainer)
    }

    @objc func didTapItem(){
        onTapItem(data?.id ?? 0)
    }
}
