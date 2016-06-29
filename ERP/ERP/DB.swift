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
    
    static func logout(user : User) {
        try! realm.write {
            user.didLogin = 0
        }
    }
    
    static func login(user : User) {
        try! realm.write {
            user.didLogin = 1
        }
    }
    
    static func getUser() -> User? {
        return realm.objects(User).first
    }
    
    static func getUserByName(name : String) -> User?{
        let predicate = NSPredicate(format: "userName = %@",name)
        return realm.objects(User).filter(predicate).first
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
    
    static func addOrUpdateInstructor(instructor: Instructor) {
        let foundInstructorOpt = realm.objects(Instructor).filter("code == '\(instructor.code)'").first
        if let foundInstructor = foundInstructorOpt {
            try! realm.write {
                // MARK: Test update classroles for instructor
                foundInstructor.classRoles = instructor.classRoles
            }
        } else {
            try! realm.write {
                realm.add(instructor)
            }
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
    
    static func getInstructorByCode(code : String) -> Instructor? {
        for instructor in DB.getAllInstructors() {
            print("\(instructor.code) == \(code)")
        }
        return realm.objects(Instructor).filter("code == '\(code)'").first
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
    
    static func updateTeachingRecord(instTeachingRecord : TeachingRecord, recordId :
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
    
    static func deleteTeachingRecord(record: TeachingRecord) {
        try! realm.write {
            realm.delete(record)
        }
    }
    
    // MARK: TeachingRecord
    static func addOrUpdateTeachingRecord(record: TeachingRecord) {
        let foundRecordOpt = realm.objects(TeachingRecord).filter("recordId = '\(record.recordId)'").first
        if foundRecordOpt != nil {
            
        } else {
            try! realm.write {
                realm.add(record)
            }
        }
    }
    
    // MARK: TeachingRecordRequest
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
