//
//  ShowCaseCollectionViewCell.swift
//  Starter
//
//  Created by KC on 11/02/2022.
//

import UIKit

class ShowCaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewBackDrop: UIImageView!
    @IBOutlet weak var labelContentTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    
    
  
    
    var data : MovieResult?{
        didSet{
            if let data = data {
                let title = data.originalTitle ?? data.originalName
                                
                let backdropPath =  "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "")"
                labelContentTitle.text = title
                imageViewBackDrop.sd_setImage(with: URL(string: backdropPath))
                labelReleaseDate.text  = data.releaseDate ?? "undefined"
                
            }
              
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
