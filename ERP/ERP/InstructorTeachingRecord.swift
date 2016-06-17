//
//  AttendanceRecord.swift
//  ERP
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import RealmSwift

class InstructorTeachingRecord : Object {
    
    dynamic var code = ""
    dynamic var classCode = ""
    dynamic var roleCode = ""
    dynamic var date = NSDate()
    dynamic var sent = false
    
    static func create(code: String, classCode: String, roleCode: String, date: NSDate) -> InstructorTeachingRecord {
        let instTeachingRecord = InstructorTeachingRecord()
        instTeachingRecord.code = code
        instTeachingRecord.classCode = classCode
        instTeachingRecord.roleCode = roleCode
        instTeachingRecord.date = date
        DB.addInstructorTeachingRecord(instTeachingRecord)
        return instTeachingRecord
    }
}

extension InstructorTeachingRecord {
    var JSON : [String : String] {
        get {
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "yyy-MM-dd"
            return [
                "code" : self.code,
                "class" : self.classCode,
                "role" : self.roleCode,
                "date" : dateFormater.stringFromDate(self.date)
            ]
        }
    }
}

