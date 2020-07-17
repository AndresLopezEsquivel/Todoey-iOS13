//
//  Item.swift
//  Todoey
//
//  Created by Andres Lopez Esquivel on 17/07/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class Item
{
    var title : String
    var done : Bool
    
    init(title : String, done : Bool)
    {
        self.title = title
        self.done = done
    }
}
