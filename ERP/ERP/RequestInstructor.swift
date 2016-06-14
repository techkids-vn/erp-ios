//
//  RequestInstructor.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Alamofire
import JASON
import RealmSwift

let INSTRUCTOR_API = "https://erp-dump.herokuapp.com/api/instructors"
class RequestInstructor: NSObject {
   
    static func getInstructor() -> [Instructor] {
        var instructors = [Instructor]()
        Alamofire.request(.GET, INSTRUCTOR_API)
            .validate()
            .responseJASON { response in
                if let json = response.result.value {
                   for dict in json[.items] {
                        let imgUrl = dict[.image]
                        let name = dict[.name]
                        let code = dict[.code]
                        let team = dict[.team]
                        let classes = dict[.classes]
                        
                        let classRoles = List<ClassRole>()
                        for c in classes {
                            let role = c["role"].stringValue
                            let code = c["code"].stringValue
                            classRoles.append(ClassRole.create(code, roleCode: role))
                        }
                        instructors.append(Instructor.create(imgUrl, name: name, team: team, code: code, classRoles: classRoles))
                    }
                }
                
        }
        return instructors
    }
    
    
}
