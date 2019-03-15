//
//  Category.swift
//  BusyHub
//
//  Created by Emanuel Covaci on 15/03/2019.
//  Copyright © 2019 Emanuel Covaci. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
