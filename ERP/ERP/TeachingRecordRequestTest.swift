//
//  TeachingRecordRequestTest.swift
//  ERP
//
//  Created by admin on 6/24/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation

class TeachingRecordRequestTest: NSObject {
    
    static func TestDB() {
        DB.deleteAllTeachingRecordRequests()
        DB.deleteAllInstructorTeachingRecords()
        
        let t = TeachingRecordRequest()
        DB.addTeachingRecordRequest(t)
        print(DB.getAllTeachingRecordRequests().count)
        assert(DB.getAllTeachingRecordRequests().count == 1)
    }
    
    static func testSendCreateRecord() {
        
        DB.deleteAllInstructorTeachingRecords()
        
        let now = NSDate.init(timeIntervalSinceNow: 0)
        
        let record = TeachingRecord.create("002004", classCode: "ios4", roleCode: "coach", date: now)
        
        let recordRequest = TeachingRecordRequest.create(record, requestType: RequestType.CREATE)
        
        NetworkContext.sendTeachingRecordRequest(recordRequest, requestDone: {
            code, message in
            print(message)
            DB.deleteAllTeachingRecordRequests()
        })
    }
    
}