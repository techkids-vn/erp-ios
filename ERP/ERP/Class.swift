//
//  Role.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import JASON

class Class: NSObject {
    
    var role : NSArray = []
    var code : String = ""

    init(_ json : JSON) {
        code = json[.code]
        let roleKey    = JSONKey<NSArray>("role")
        role = json[roleKey]
    }
    
}
