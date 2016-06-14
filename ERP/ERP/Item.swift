//
//  Item.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import JASON

class Item: NSObject {
    var image   : String  = ""
    var name    : String  = ""
    var team    : String  = ""
    var classes : [Class] = []
    var code    : String = ""
    
    init(_ json : JSON) {
        image = json[.image]
        name  = json[.name]
        team  = json[.team]
        classes = json[.classes].map(Class.init)
        code  = json[.code]
    }
}
