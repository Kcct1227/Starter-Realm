//
//  ActorCollectionViewCell.swift
//  Starter
//
//  Created by KC on 11/02/2022.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var ivHeartFill: UIImageView!
    
    @IBOutlet weak var imageViewActorProfile: UIImageView!
    @IBOutlet weak var labelActorName : UILabel!
    @IBOutlet weak var labelKnownForDeaprtMent : UILabel!
    
    weak var delegate: ActorActionDelegate?=nil
    
    var data : ActorInfoResponse? {
        didSet{
            if let data = data {
                let backdropPath =  "\(AppConstants.baseImageUrl)/\(data.profilePath ?? "")"
                imageViewActorProfile.sd_setImage(with: URL(string:backdropPath))
                labelActorName.text = data.name
                labelKnownForDeaprtMent.text = data.knownForDepartment
                                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initGestureRecognizers()
    }
    
    private func initGestureRecognizers(){
        
        let tapGestureFavorie = UITapGestureRecognizer(target: self, action: #selector(onTapFavorite))
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestureFavorie)
        
        let tapGestureUnFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapUnfavorite))
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestureUnFavorite)
        
    }
    
    @objc func onTapFavorite(){
        ivHeartFill.isHidden = true
        ivHeart.isHidden  = false
        delegate?.onTapFavorite(isFavorite: true)
    }
    
    @objc func onTapUnfavorite(){
        ivHeartFill.isHidden = false
        ivHeart.isHidden = true
        delegate?.onTapFavorite(isFavorite: false)
    }

}
