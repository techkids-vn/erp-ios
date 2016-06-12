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
    
    static func getLogin() -> Login? {
        let result = realm.objects(Login.self).first
        return result
    }

}
