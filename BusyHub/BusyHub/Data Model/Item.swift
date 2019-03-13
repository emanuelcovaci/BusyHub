//
//  Item.swift
//  BusyHub
//
//  Created by Emanuel Covaci on 08/03/2019.
//  Copyright © 2019 Emanuel Covaci. All rights reserved.
//

import Foundation

class Item : Codable{
    var title: String = ""
    var done: Bool = false
    
    init(){
        
    }
    
    init(title:String,done:Bool) {
            self.title = title
            self.done = done
    }
}
