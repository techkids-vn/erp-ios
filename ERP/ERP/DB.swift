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
    
    static func loginFirstTime(login : Login) {
        try! realm.write {
            realm.add(login)
        }
    }
    
    static func addInstructor(instructor: Instructor) {
        try! realm.write {
            realm.add(instructor);
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
            try!  realm.write {
                realm.delete(instructor)
            }
        }
    }
    
    static func getLogin() -> Login? {
        let result = realm.objects(Login.self).first
        return result
    }

}
