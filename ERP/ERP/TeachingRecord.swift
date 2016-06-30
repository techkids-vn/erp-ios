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
    dynamic var userName = ""
    dynamic var recordTime = ""
    
    static func create(code: String, classCode: String, roleCode: String, date: NSDate, recordTime : String, recordId : String, userName : String) -> TeachingRecord {
        let teachingRecord = TeachingRecord()
        teachingRecord.code = code
        teachingRecord.classCode = classCode
        teachingRecord.roleCode = roleCode
        teachingRecord.date = date
        teachingRecord.recordId = recordId
        teachingRecord.userName = userName
        teachingRecord.recordTime = recordTime
        DB.addOrUpdateTeachingRecord(teachingRecord)
        return teachingRecord
    }
    
    static func create(code: String, classCode: String, roleCode: String, date: NSDate, recordTime : String) -> TeachingRecord {
        
        return create(code, classCode: classCode, roleCode: roleCode, date: date,recordTime: recordTime, recordId: "", userName: "")
    }
    
    static func create(json : JSON) -> TeachingRecord {
        print(json)
        let code = json[.instructorCode]
        let classCode = json[.classCode]
        let roleCode = json[.roleCode]
        let date = json[.date].date // MARK: Add code to secure date conversion
        let recordId = json[.id]
        let userName = json[.userName]
        let recordTime = json[.recordTime]
        
        let record = create(
            code,
            classCode: classCode,
            roleCode: roleCode,
            date: date,
            recordTime: recordTime,
            recordId: recordId,
            userName: userName)
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
        return retValue.sort{ x, y in return x.dateString! > y.dateString! }
    }
}

extension TeachingRecord {
    var Dict : [String : String] {
        get {
            return [
                "instructor_code" : self.code,
                "class_code" : self.classCode,
                "role_code" : self.roleCode,
                "date" : self.date.string,
                "_id" : self.recordId,
                "record_time" : self.recordTime
            ]
        }
    }
    
    var instructor : Instructor? {
        get {
            print(self.code)
            return DB.getInstructorByCode(self.code)
        }
    }
    
    var classTitle : String {
        get {
            return Class.getTitle(self.classCode)
        }
    }
    
    var roleTitle : String {
        get {
            return Role.getTitle(self.roleCode)
        }
    }
    
    var editable : Bool {
        get {
            if let user = DB.getUser() {
                if user.userName == self.userName {
                    return true
                }
            }
            return false
        }
    }
}



