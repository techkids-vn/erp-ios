//
//  Instructortest.swift
//  ERP
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import RealmSwift

class InstructorTest : NSObject {
    
    /**
     Note: run this test will cause all of instructor data to be ereased
    */
    static func testAddInstructor() {
        
        DB.deleteAllInstructors()
        
        let classRole1 = ClassRole.create("ios5", roleCode: "coach")
        let classRole2 = ClassRole.create("ios6", roleCode: "coach")
        let classRole3 = ClassRole.create("ios6", roleCode: "inst")
        let classRoles = List<ClassRole>()
        classRoles.append(classRole1)
        classRoles.append(classRole2)
        classRoles.append(classRole3)
        let instructor = Instructor.create("ImageLink", name: "Nguyen Son Vu", team: "ios", code: "TEC0010", classRoles: classRoles)
        
        DB.addInstructor(instructor);
        
        let allInstructors = DB.getAllInstructors()
        assert(allInstructors.count == 1)
        
        let insertedInstructor = allInstructors[0]
        assert(insertedInstructor.imgUrl == "ImageLink")
        assert(insertedInstructor.name == "Nguyen Son Vu")
        assert(insertedInstructor.team == "ios")
        assert(insertedInstructor.code == "TEC0010")
        assert(insertedInstructor.classRoles.count == 3)
    }
}