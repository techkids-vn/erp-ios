//
//  Role.swift
//  ERP
//
//  Created by admin on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import RealmSwift
import JASON

class Role: Object {
    dynamic var code = ""
    dynamic var title = ""
    
    static var all : [Role] = []
    
    static override func ignoredProperties() -> [String] { return ["all"] }
    
    static func create(code: String, title: String) -> Role {
        let role = Role()
        role.code = code
        role.title = title
        return role
    }
    
    static func create(json: JSON) -> Role {
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
}
