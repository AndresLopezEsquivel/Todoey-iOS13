//
//  Category.swift
//  Todoey
//
//  Created by Andres Lopez Esquivel on 11/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object
{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
