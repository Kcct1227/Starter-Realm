//
//  MoviewItemDelegate.swift
//  Starter
//
//  Created by KC on 11/02/2022.
//

import Foundation

protocol MovieItemDelegate : AnyObject{
    func onTapMovie(id : Int, type: String)
}
