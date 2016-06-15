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


class Login: Object {
    dynamic var didLogin : Int = 0
    dynamic var userName : String = ""
    dynamic var password : String = ""
    
    static func create(userName: String, password: String) -> Login {
        let login = Login()
        login.userName = userName
        login.password = password
        login.didLogin = 1
        DB.loginFirstTime(login)
        return login
    }
    
}

extension Login {
    typealias RequestDone = (Int) -> Void
    
    static func checkLogin(username : String, password : String, requestDone: RequestDone) {
        let loginRequest = [
            "username" : username,
            "password" : password
        ]

        let paramURLEncoding = ParameterEncoding.Custom { (request, params) -> (NSMutableURLRequest, NSError?) in
            
            let urlEncoding = Alamofire.ParameterEncoding.URLEncodedInURL
            let (urlRequest, error) = urlEncoding.encode(request, parameters: params)
            let mutableRequest = urlRequest.mutableCopy() as! NSMutableURLRequest
            mutableRequest.URL = NSURL(string: LOGIN_API)
            mutableRequest.HTTPBody = urlRequest.URL?.query?.dataUsingEncoding(NSUTF8StringEncoding)
            return (mutableRequest, error)
        }
        
        Alamofire.request(.POST, LOGIN_API, parameters: loginRequest, encoding: paramURLEncoding, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            if let reportData = response.result.value {
                let statusLogin = reportData["login_status"] as! Int
                requestDone(statusLogin)
            }
        }
        
    }
}
