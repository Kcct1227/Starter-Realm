//
//  MovieSliderCollectionViewCell.swift
//  Starter
//
//  Created by KC on 09/02/2022.
//

import UIKit
import SDWebImage

class MovieSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewBackDrop: UIImageView!
    @IBOutlet weak var labelContentTitle: UILabel!
  
    
    var data : MovieResult?{
        didSet{
            if let data = data {
                let title = data.originalTitle
                let backdropPath =  "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? data.posterPath ?? "")"
                labelContentTitle.text = title
                imageViewBackDrop.sd_setImage(with: URL(string: backdropPath))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
