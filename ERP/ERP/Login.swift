//
//  Login.swift
//  ERP
//
//  Created by Mr.Vu on 6/13/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RealmSwift

class Login: Object {
    dynamic var didLogin : Int = 0
    
    static func create() ->Login {
        let login = Login()
        login.didLogin = 1
        DB.loginFirstTime(login)
        return login
    }
    
}
