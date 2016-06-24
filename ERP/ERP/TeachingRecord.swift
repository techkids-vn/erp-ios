//
//  AttendanceRecord.swift
//  ERP
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import RealmSwift
import JASON

class TeachingRecord : Object {
    
    dynamic var code = ""
    dynamic var classCode = ""
    dynamic var roleCode = ""
    dynamic var date = NSDate()
    dynamic var recordId = ""
    
    static func create(code: String, classCode: String, roleCode: String, date: NSDate, recordId : String) -> TeachingRecord {
        let teachingRecord = TeachingRecord()
        teachingRecord.code = code
        teachingRecord.classCode = classCode
        teachingRecord.roleCode = roleCode
        teachingRecord.date = date
        teachingRecord.recordId = recordId
        DB.addOrUpdateTeachingRecord(teachingRecord)
        return teachingRecord
    }
    
    static func create(code: String, classCode: String, roleCode: String, date: NSDate) -> TeachingRecord {
        return create(code, classCode: classCode, roleCode: roleCode, date: date, recordId: "")
    }
    
    static func create(json : JSON) -> TeachingRecord {
        print(json)
        let code = json[.instructorCode]
        let classCode = json[.classCode]
        let roleCode = json[.roleCode]
        let date = json[.date].date // MARK: Add code to secure date conversion
        let recordId = json[.id][.oid]

        let record = create(
            code,
            classCode: classCode,
            roleCode: roleCode,
            date: date,
            recordId: recordId)
        return record
    }
  
    static func groupByDate(teachingRecords: [TeachingRecord]) -> [TeachingRecordGroup] {
        var retValue : [TeachingRecordGroup] = []
        for teachingRecord in teachingRecords {
            let date = teachingRecord.date.string
            let groupOpt = retValue.filter {
                group in
                return group.dateString! == date
            }.first
            if let group = groupOpt {
                group.teachingRecords!.append(teachingRecord)
            } else {
                retValue.append(TeachingRecordGroup(dateString: date, teachingRecords: [teachingRecord]))
            }
        }
        return retValue
    }
}

extension TeachingRecord {
    var Dict : [String : String] {
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



