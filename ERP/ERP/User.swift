//
//  Login.swift
//  ERP
//
//  Created by Mr.Vu on 6/13/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class User: Object {
    dynamic var didLogin : Int = 0
    dynamic var userName : String = ""
    dynamic var password : String = ""
    
    static func create(userName: String, password: String) -> User {
        let login = User()
        login.userName = userName
        login.password = password
        login.didLogin = 1
        DB.loginFirstTime(login)
        return login
    }
}

extension User {
    static func checkLogin(username : String, password : String, requestDone: RequestDone) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "login" : username,
            "pass" : password,
            "dbId" : "1"
        ]
        let url = NSURL(string: LOGIN_API)!
        Alamofire.request(.POST, url, parameters: parameters, headers: headers, encoding: .URL)
            .responseString { response in
                requestDone(1,response.description)
        }
        
    }
    
}
