//
//  NetworkContext.swift
//  ERP
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 Techkids. All rights reserved.
//
import Foundation
import Alamofire
import JASON

typealias RequestDone = (Int, String) -> Void
typealias TeachingRecordFecthDone = ([TeachingRecord]) -> Void
typealias FetchDone = ([AnyObject]) -> Void

class NetworkContext {
    
    static let RESULT_CODE_FAILURE = 0
    static let RESULT_CODE_SUCCESS = 1
    
    private static func addUserName(inout json : [String:String]) -> [String:String]{
        if let user = DB.getUser() {
            json["user_name"] = user.userName
        }
        return json
    }
    
    // MARK: TeachingRecord Request
    static func sendTeachingRecordRequest(request : TeachingRecordRequest, requestDone : RequestDone?) {
        var parameters = request.record?.Dict
        _ = addUserName(&parameters!)
        
        var apiUrl = ""
        switch request.requestType {
        case RequestType.CREATE:
            apiUrl = ADD_RECORD_INSTRUCTOR_API
            break
        case RequestType.UPDATE:
            apiUrl = UPDATE_RECORD_INSTRUCTOR_API
            break
        case RequestType.DELETE:
            apiUrl = DELETE_RECORD_INSTRUCTOR_API
            break
        }
        
        Alamofire.request(.POST,
            apiUrl,
            parameters: parameters,
            encoding: .URL,
            headers: nil)
            .responseJASON {
                response in
                if let json = response.result.value {
                    print(json)
                    let responseMessage = ResponseMessageWithRecordId.init(json: json)
                    request.handleResponse(responseMessage)
                    if responseMessage.isSuccess {
                        if let done = requestDone {
                            done(RESULT_CODE_SUCCESS, "Requested sucessfully")
                        }
                    } else {
                        if let done = requestDone {
                            done(RESULT_CODE_FAILURE, "Server responded but request failed")
                        }
                    }
                } else {
                    if let done = requestDone {
                        done(RESULT_CODE_FAILURE, "Server did not respond or did not understand the paramters")
                    }
                }
        }
    }
    
    static func fetchAllTeachingRecords(requestDone : TeachingRecordFecthDone) {
        Alamofire.request(.GET, GET_RECORD_INSTRUCTOR_API)
        .validate()
        .responseJASON {
            response in
            if let json = response.result.value {
                print(json)
                let teachingRecords = json[.items].map(TeachingRecord.create)
                requestDone(teachingRecords)
            }
        }
    }
    
    // MARK: Class
    static func fetchAllClasses(fetchDone : FetchDone) {
        Alamofire.request(.GET, GET_CLASS_API)
            .validate()
            .responseJASON {
                response in
                if let json = response.result.value {
                    let classes = json[.items].map {
                        classJSON in
                        return Class.create(classJSON) as AnyObject
                    }
                    fetchDone(classes)
                }
        }
    }
    
    
    // MARK: Role
    static func fetchAllRoles(fetchDone: FetchDone) {
        Alamofire.request(.GET, GET_ROLE_API)
            .validate()
            .responseJASON {
                response in
                if let json = response.result.value {
                    let roles = json[.items].map {
                        roleJSON in
                        return Role.create(roleJSON) as AnyObject
                    }
                    fetchDone(roles)
                }
        }
    }
}