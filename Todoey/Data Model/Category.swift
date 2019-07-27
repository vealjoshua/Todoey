//
//  Category.swift
//  Todoey
//
//  Created by Joshua Veal on 4/22/19.
//  Copyright © 2019 Joshua Veal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
