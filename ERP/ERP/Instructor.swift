//
//  Instructor.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class Instructor: NSObject {
    
    dynamic var imgUrl = ""
    dynamic var name = ""
    dynamic var code = ""
    dynamic var team = ""
    
    func create(imgUrl : String, name : String, team : String, code : String) -> Instructor {
        let instructor = Instructor()
        instructor.imgUrl = imgUrl
        instructor.name = name
        instructor.team = team
        instructor.code = code
        
        return instructor
    }
    
}
