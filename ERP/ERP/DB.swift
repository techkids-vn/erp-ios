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
    
    // MARK: Login
    static func loginFirstTime(login : User) {
        try! realm.write {
            realm.add(login)
        }
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
    
    // MARK: InstructorTeachingRecord
    static func addInstructorTeachingRecord(instTeachingRecord : InstructorTeachingRecord) {
        try! realm.write {
            realm.add(instTeachingRecord)
        }
    }
    
    static func getAllInstructorTeachingRecords() -> [InstructorTeachingRecord] {
        return realm.objects(InstructorTeachingRecord).map {
            record in
            return record
        }
    }
    
    static func updateInstructorTeachingRecord(instTeachingRecord : InstructorTeachingRecord, recordId : Int) {
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
}
