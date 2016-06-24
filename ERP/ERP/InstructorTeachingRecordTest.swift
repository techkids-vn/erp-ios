//
//  InstructorTeachingRecordTest.swift
//  ERP
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation

class InstructorTeachingRecordTest : NSObject {
    
    static func testCreateRecord() {
        
        DB.deleteAllInstructorTeachingRecords()
        
        let now = NSDate.init(timeIntervalSinceNow: 0)
        
        _ = TeachingRecord.create("002004", classCode: "ios4", roleCode: "coach", date: now)
        
        let allRecords = DB.getAllInstructorTeachingRecords()
        assert(allRecords.count == 1)
        let oneRecord = allRecords[0]
        assert(oneRecord.code == "002004")
        assert(oneRecord.classCode == "ios4")
        assert(oneRecord.roleCode == "coach")
        assert(now.isEqualToDate(oneRecord.date))
        
        DB.deleteAllInstructorTeachingRecords()
    }
    
    static func testUpdateInstructorTeachingRecordSent() {
        DB.deleteAllInstructorTeachingRecords()
        
        let now = NSDate.init(timeIntervalSinceNow: 0)
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        _ = TeachingRecord.create("002004", classCode: "ios4", roleCode: "coach", date: now)
        
        let allRecords = DB.getAllInstructorTeachingRecords()
        assert(allRecords.count == 1)
        let oneRecord = allRecords[0]
        assert(oneRecord.code == "002004")
        assert(oneRecord.classCode == "ios4")
        assert(oneRecord.roleCode == "coach")
        assert(now.isEqualToDate(oneRecord.date))
        
        assert(oneRecord.recordId == "")
        
        DB.updateInstructorTeachingRecord(oneRecord, recordId: "123456")
        
        let allRecords2 = DB.getAllInstructorTeachingRecords()
        assert(allRecords.count == 1)
        let oneRecord2 = allRecords2[0]
        assert(oneRecord2.recordId == "123456")
        
        DB.deleteAllInstructorTeachingRecords()
    }

    
    static func testFetchAllTeachingRecords () {
        NetworkContext.fetchAllTeachingRecords(
            {
                records in
                print(records.count)
                for record in records {
                    print(record.code)
                }
            }
        )
    }
    
    static func dumpInstructorRecord() {
        let instructors = DB.getAllInstructors()
        let now = NSDate.init(timeIntervalSinceNow: 0)
        for i in 0..<instructors.count {
            _ = TeachingRecord.create(instructors[i].code, classCode: "ios4" , roleCode: "coach", date: now)
        }
    }
    
}