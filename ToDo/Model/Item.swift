//
//  Item.swift
//  ToDo
//
//  Created by Karol Struniawski on 10/11/2018.
//  Copyright © 2018 Karol Struniawski. All rights reserved.
//

import Foundation

class Item : Codable{
    var name : String = ""
    var done : Bool = false
    
    init(name : String){
        self.name = name
    }
    init(){
        
    }
    
}
