//
//  ProductionCompainiesCell.swift
//  Starter
//
//  Created by KC on 12/03/2022.
//

import UIKit

class ProductionCompainiesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewBackdrop : UIImageView!
    @IBOutlet weak var labelCompanyName : UILabel!
    
    var data: ProductionCompany?{
        didSet{
            if let data = data{
                let backdropPath =  "\(AppConstants.baseImageUrl)/\(data.logoPath ?? "")"
                imageViewBackdrop.sd_setImage(with: URL(string: backdropPath))
                
                if data.logoPath == nil || data.logoPath!.isEmpty {
                    labelCompanyName.text  = data.name ?? ""
                }else{
                    labelCompanyName.text = ""
                }
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
