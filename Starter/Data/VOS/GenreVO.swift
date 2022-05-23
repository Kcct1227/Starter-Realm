//
//  GenreVO.swift
//  Starter
//
//  Created by KC on 10/02/2022.
//

import Foundation

class GenreVO{
    
    var id: Int = 0
    var name: String = "ACTION"
    var isSelected: Bool = false
    
    
    init(id: Int = 0,name:String, isSelected: Bool){
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}
