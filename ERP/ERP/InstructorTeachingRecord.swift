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
    dynamic var recordId = -1
    
    static func create(code: String, classCode: String, roleCode: String, date: NSDate) -> InstructorTeachingRecord {
        let instTeachingRecord = InstructorTeachingRecord()
        instTeachingRecord.code = code
        instTeachingRecord.classCode = classCode
        instTeachingRecord.roleCode = roleCode
        instTeachingRecord.date = date
        DB.addInstructorTeachingRecord(instTeachingRecord)
        return instTeachingRecord
    }
    
    static func groupByDate(teachingRecords: [InstructorTeachingRecord]) -> [String: InstructorTeachingRecord] {
        var retDict : [String: InstructorTeachingRecord] = [:]
        for teachingRecord in teachingRecords {
            let date = teachingRecord.date.dateString
            retDict[date] = teachingRecord
        }
        return retDict
    }
}

extension InstructorTeachingRecord {
    var JSON : [String : String] {
        get {
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            return [
                "code" : self.code,
                "class" : self.classCode,
                "role" : self.roleCode,
                "date" : dateFormater.stringFromDate(self.date),
                "record_id" : "\(self.recordId)"
            ]
        }
    }
}

