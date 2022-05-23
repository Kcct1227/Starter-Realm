//
//  RatingControl.swift
//  Starter
//
//  Created by KC on 09/02/2022.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {
    
    @IBInspectable var starSize: CGSize = CGSize(width: 50.0, height: 50.0){
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    @IBInspectable var rating : Int = 3{
        didSet {
            updateButtonRating()
        }
    }
    
    var ratingButtons = [UIButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
        updateButtonRating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
        updateButtonRating()
    }
    
    private func setUpButtons(){
        
        clearExistingButton()
        
        for _ in 0..<starCount{
            let button = UIButton()
            //button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            button.setImage(UIImage(named: "filledStar"), for: .selected)
            button.setImage(UIImage(named: "emptyStar"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            addArrangedSubview(button)
            button.isUserInteractionEnabled = false
            ratingButtons.append(button)
        }
        
    }
    
    private func clearExistingButton(){
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
    }
    
    private func updateButtonRating(){
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
        }
    }
    
}
