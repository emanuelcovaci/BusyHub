//
//  Item.swift
//  BusyHub
//
//  Created by Emanuel Covaci on 15/03/2019.
//  Copyright © 2019 Emanuel Covaci. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated:Date = Date.init()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
