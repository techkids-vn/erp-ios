//
//  DB.swift
//  ERP
//
//  Created by Mr.Vu on 6/13/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import RealmSwift

class DB: Object {
    
    static let realm = try! Realm()
    
    // MARK: User
    static func loginFirstTime(login : User) {
        try! realm.write {
            realm.add(login)
        }
    }
    
    static func getUser() -> User? {
        return realm.objects(User).first
    }
    
    static func getLogin() -> User? {
        let result = realm.objects(User).first
        return result
    }
    
    // MARK: Instructor
    static func addInstructor(instructor: Instructor) {
        try! realm.write {
            realm.add(instructor);
        }
    }
    
    static func findInstructorByCode(code: String) -> Instructor? {
        let foundInstructors = realm.objects(Instructor).filter("code == \(code)")
        if foundInstructors.count == 0 {
            return nil
        } else if (foundInstructors.count == 1) {
            return foundInstructors[0];
        } else {
            print("Inconsistent database: More than one intructor with indentical code")
            return foundInstructors[0];
        }
    }
    
    static func getAllInstructors() -> [Instructor] {
        return realm.objects(Instructor).map({
            instructor in
            return instructor
        })
    }
    
    static func deleteAllInstructors() {
        let instructors = getAllInstructors()
        for instructor in instructors {
            try! realm.write {
                realm.delete(instructor)
            }
        }
    }
    
    // MARK: TeachingRecord
    static func addInstructorTeachingRecord(instTeachingRecord : TeachingRecord) {
        try! realm.write {
            realm.add(instTeachingRecord)
        }
    }
    
    static func getAllInstructorTeachingRecords() -> [TeachingRecord] {
        return realm.objects(TeachingRecord).map {
            record in
            return record
        }
    }
    
    static func updateInstructorTeachingRecord(instTeachingRecord : TeachingRecord, recordId :
        String) {
        try! realm.write {
            instTeachingRecord.recordId = recordId
        }
    }
    
    static func deleteAllInstructorTeachingRecords() {
        for instRecord in getAllInstructorTeachingRecords() {
            try! realm.write {
                realm.delete(instRecord)
            }
        }
    }
    
    static func getInstructorTeachingRecordCountForToday(instructor : Instructor) -> Int {
        // get today NSDate
        // get code
        // get from realm
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year = components.year - components.year/1000
        let month = components.month
        let day = components.day
        let currentTime = "\(year)-\(month)-\(day)"
        
        var count = 0
        for instRecord in getAllInstructorTeachingRecords() {
            if instructor.code == instRecord.code && instRecord.date == currentTime{
                count += 1
            }
        }
        
        return count
    }
    
    // MARK: TeachingRecord Request
    static func addTeachingRecordRequest(request : TeachingRecordRequest) {
        try! realm.write {
            realm.add(request)
        }
    }
    
    static func getAllTeachingRecordRequests() -> [TeachingRecordRequest] {
        return realm.objects(TeachingRecordRequest).map {
            item in
            return item
        }
    }
    
    static func deleteAllTeachingRecordRequests() {
        for request in getAllTeachingRecordRequests() {
            try! realm.write {
                realm.delete(request)
            }
        }
    }
    
    static func updateTeachingRecordRequest(request : TeachingRecordRequest, status: RequestStatus) {
        try! realm.write {
            request.status = status
        }
    }
}
