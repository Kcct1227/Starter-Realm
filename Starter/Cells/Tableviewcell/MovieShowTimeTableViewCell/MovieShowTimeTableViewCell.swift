//
//  MovieShowTimeTableViewCell.swift
//  Starter
//
//  Created by KC on 10/02/2022.
//

import UIKit

class MovieShowTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSeeMore: UILabel!
    @IBOutlet weak var viewForBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        viewForBackground.layer.cornerRadius = 4
        //viewForBackground.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
        
        
        lblSeeMore.underLineText(text: "SEE MORE")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
