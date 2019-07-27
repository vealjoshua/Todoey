//
//  Item.swift
//  Todoey
//
//  Created by Joshua Veal on 4/22/19.
//  Copyright © 2019 Joshua Veal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
