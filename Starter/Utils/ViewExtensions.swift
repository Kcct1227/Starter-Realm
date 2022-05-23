//
//  ViewExtensions.swift
//  Starter
//
//  Created by KC on 10/02/2022.
//

import Foundation
import UIKit

extension UILabel{
    func underLineText(text: String){
        let attributedString = NSMutableAttributedString.init(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length:  attributedString.length))
        self.attributedText = attributedString
    }
}

extension UITableViewCell{
    static var identifier: String{
        String(describing: self)
    }
}

extension UITableView{
    func registerForCell(identifier:String){
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UITableViewCell>(identifier:String, indexPath:IndexPath)->T{
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else{
            return UITableViewCell() as! T
        }
        return cell
    }
}

extension UICollectionViewCell{
    static var identifier: String{
        String(describing: self)
    }
}

extension UICollectionView{
    func registerForCell(identifier:String){
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UICollectionViewCell>(identifier:String, indexPath:IndexPath)->T{
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else{
            return UICollectionViewCell() as! T
        }
        return cell
    }
}

extension UIViewController{
    static var identifer: String{
        String(describing: self)
    }
}

