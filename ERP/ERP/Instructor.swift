//
//  Instructor.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RealmSwift

class Instructor: Object {
    
    dynamic var imgUrl = ""
    dynamic var name = ""
    dynamic var code = ""
    dynamic var team = ""
    dynamic var numberAttendance = 0
    var classRoles : List<ClassRole> = List<ClassRole>()
    
    static func create(imgUrl : String, name : String, team : String, code : String, classRoles : List<ClassRole>) -> Instructor {
        
        let instructor = Instructor()
        instructor.imgUrl = imgUrl
        instructor.name = name
        instructor.team = team
        instructor.code = code
        instructor.classRoles = classRoles;
        
        return instructor
    }
    
}
