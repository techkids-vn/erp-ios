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

let loginAPI = "https://erp-dump.herokuapp.com/api/login"

class Login: Object {
    dynamic var didLogin : Int = 0
    
    static func create() ->Login {
        let login = Login()
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
            mutableRequest.URL = NSURL(string: loginAPI)
            mutableRequest.HTTPBody = urlRequest.URL?.query?.dataUsingEncoding(NSUTF8StringEncoding)
            return (mutableRequest, error)
        }
        
        Alamofire.request(.POST, loginAPI, parameters: loginRequest, encoding: paramURLEncoding, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            if let reportData = response.result.value {
                let statusLogin = reportData["login_status"] as! Int
                requestDone(statusLogin)
            }
        }
        
    }
}
