//
//  Category.swift
//  Todoey
//
//  Created by Alberto Hernandez Testa on 9/1/19.
//  Copyright © 2019 Alberto Hernandez Testa. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
