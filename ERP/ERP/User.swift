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
        let loginRequest = [
            "username" : username,
            "password" : password
        ]
        
        Alamofire.request(.POST, LOGIN_API, parameters: loginRequest, encoding: .URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            if let reportData = response.result.value {
                let statusLogin = reportData["result_code"] as! Int
                requestDone(statusLogin, "Login done")
            }
        }
        
    }
    
}
