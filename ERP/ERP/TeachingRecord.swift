//
//  AttendanceRecord.swift
//  ERP
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import RealmSwift

class TeachingRecord : Object {
    
    dynamic var code = ""
    dynamic var classCode = ""
    dynamic var roleCode = ""
    dynamic var date = NSDate()
    dynamic var recordId = ""
    
    static func create(code: String, classCode: String, roleCode: String, date: NSDate) -> TeachingRecord {
        let instTeachingRecord = TeachingRecord()
        instTeachingRecord.code = code
        instTeachingRecord.classCode = classCode
        instTeachingRecord.roleCode = roleCode
        instTeachingRecord.date = date
        DB.addInstructorTeachingRecord(instTeachingRecord)
        return instTeachingRecord
    }
    
    static func groupByDate(teachingRecords: [TeachingRecord]) -> [String: TeachingRecord] {
        var retDict : [String: TeachingRecord] = [:]
        for teachingRecord in teachingRecords {
            let date = teachingRecord.date.dateString
            retDict[date] = teachingRecord
        }
        return retDict
    }
}

extension TeachingRecord {
    var JSON : [String : String] {
        get {
            return [
                "code" : self.code,
                "class" : self.classCode,
                "role" : self.roleCode,
                "date" : self.date.string,
                "record_id" : self.recordId
            ]
        }
    }
}



