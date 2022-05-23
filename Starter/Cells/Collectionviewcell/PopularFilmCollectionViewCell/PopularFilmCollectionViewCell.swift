//
//  PopularFilmCollectionViewCell.swift
//  Starter
//
//  Created by KC on 10/02/2022.
//

import UIKit

class PopularFilmCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var ratingStar: RatingControl!
    @IBOutlet weak var imageViewBackDrop: UIImageView!
    @IBOutlet weak var labelContentTitle: UILabel!
  
    
    var data : MovieResult?{
        didSet{
            if let data = data {
                let title = data.originalTitle ?? data.originalName
                                
                let backdropPath =  "\(AppConstants.baseImageUrl)/\(data.posterPath ?? "")"
                labelContentTitle.text = title
                imageViewBackDrop.sd_setImage(with: URL(string: backdropPath))
                
                let voteAverage = data.voteAverage ?? 0.0
                labelRating.text = "\(voteAverage) " //  max - 10
                ratingStar.starCount = 5
                ratingStar.rating = Int(voteAverage * 0.5) // max - 5
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
