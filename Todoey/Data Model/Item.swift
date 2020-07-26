//
//  Item.swift
//  Todoey
//
//  Created by Andres Lopez Esquivel on 17/07/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

/*
 Item conforms to Encodable protocol, so it means that an Item type
 is able to encode itself into a plist or into a JSON.
 It is important to mention that a class can be Encodable if all of its
 properties have standard data types.
 */

class Item : Encodable
{
    var title : String
    var done : Bool
    
    init(title : String, done : Bool)
    {
        self.title = title
        self.done = done
    }
}
