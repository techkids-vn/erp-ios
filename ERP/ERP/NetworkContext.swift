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

class NetworkContext {
    
    static let RESULT_CODE_FAILURE = 0
    static let RESULT_CODE_SUCCESS = 1
    
    private static func addUserName(inout json : [String:String]) -> [String:String]{
        if let user = DB.getUser() {
            json["username"] = user.userName
        }
        return json
    }
    
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
                    if responseMessage.isSuccess {
                        DB.updateInstructorTeachingRecord(request.record!, recordId: responseMessage.recordId!)
                        DB.updateTeachingRecordRequest(request, status: RequestStatus.SENT_AND_SUCCEDED)
                        if let done = requestDone {
                            done(RESULT_CODE_SUCCESS, "Requested sucessfully")
                        }
                    } else {
                        if let done = requestDone {
                            DB.updateTeachingRecordRequest(request, status: RequestStatus.SENT_AND_FAILED)
                            done(RESULT_CODE_FAILURE, "Server responded but request failed")
                        }
                    }
                } else {
                    if let done = requestDone {
                        DB.updateTeachingRecordRequest(request, status: RequestStatus.NOT_SENT)
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
                let teachingRecords = json[.items].map(TeachingRecord.create)
                requestDone(teachingRecords)
            }
        }
    }
}