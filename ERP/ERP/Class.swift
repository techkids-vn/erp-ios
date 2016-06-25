//
//  Class.swift
//  ERP
//
//  Created by admin on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import RealmSwift
import JASON

class Class: Object {
    dynamic var code = ""
    dynamic var title = ""
    
    static var all : [Class] = []
    
    static override func ignoredProperties() -> [String] { return ["all"] }
    
    static func create(code: String, title: String) -> Class {
        let cls = Class()
        cls.code = code
        cls.title = title
        return cls
    }
    
    static func create(json: JSON) -> Class {
        print(json)
        print(json[.code])
        return create(json[.code], title: json[.title])
    }
    
    static func getTitle(code: String) -> String {
        if let foundItem = all.filter ({ item in return item.code == code }).first {
            return foundItem.title
        }
        else {
            return code
        }
    }
    
    static func get(code: String) -> Class? {
        if let foundItem = all.filter ({ item in return item.code == code }).first {
            return foundItem
        }
        else {
            return nil
        }
    }
}
