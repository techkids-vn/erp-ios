//
//  Instructor.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class Instructor: Object {
    
    dynamic var imgUrl = ""
    dynamic var name = ""
    dynamic var code = ""
    dynamic var team = ""
    dynamic var phone = ""
    var classRoles : List<ClassRole> = List<ClassRole>()
     static func create(imgUrl : String, name : String, team : String, code : String,phone : String, classRoles : List<ClassRole>) -> Instructor {
        
        let instructor = Instructor()
        instructor.imgUrl = imgUrl
        instructor.name = name
        instructor.team = team
        instructor.code = code
        instructor.phone = phone
        instructor.classRoles = classRoles;
        DB.addOrUpdateInstructor(instructor)
        return instructor
    }
    
}

extension Instructor {
    var classes : [String] {
        get {
            var classCodes : [String] = []
            for classRole in self.classRoles {
                let classCode = classRole.classCode
                if !classCodes.contains(classCode) {
                    classCodes.append(Class.getTitle(classRole.classCode))
                }
            }
            return classCodes
        }
    }
    
    var roles : [String] {
        get {
            var roleCodes : [String] = []
            for classRole in self.classRoles {
                let roleCode = classRole.roleCode
                if !roleCodes.contains(roleCode) {
                    roleCodes.append(Role.getTitle(roleCode))
                }
            }
            return roleCodes
        }
    }
    
    func roleInClass(classCode : String) -> [String] {
        //MARK: For Vu
        var roleCode = [String]()
        for classRole in self.classRoles {
            if classRole.classCode == classCode {
                roleCode.append(classRole.roleCode)
            }
        }
        return roleCode
    }
    
}
