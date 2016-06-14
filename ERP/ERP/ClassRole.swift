//
//  Class.swift
//  ERP
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import RealmSwift

class ClassRole : Object {
    dynamic var classCode = ""
    dynamic var roleCode = ""
    
    static func create(classCode : String, roleCode: String) -> ClassRole {
        let c = ClassRole();
        c.classCode = classCode;
        c.roleCode = roleCode;
        return c;
    }
}
