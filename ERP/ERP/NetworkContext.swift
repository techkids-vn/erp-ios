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

class NetworkContext {
    
    static let RESULT_CODE_FAILURE = 0
    static let RESULT_CODE_SUCCESS = 1

    static func postInstructorTeachingRecord(instTeachingRecord : InstructorTeachingRecord, requestDone : RequestDone?) {
        
        let paramters = instTeachingRecord.JSON
        
        Alamofire.request(.POST,
            ADD_RECORD_INSTRUCTOR_API,
            parameters: paramters,
            encoding: .URL,
            headers: nil)
            .responseJASON {
                response in
                if let json = response.result.value {
                    print(json)
                    let responseMessage = ResponseMessageWithRecordId.init(json: json)
                    if responseMessage.isSuccess {
                        DB.updateInstructorTeachingRecord(instTeachingRecord, recordId: responseMessage.recordId!)
                        if let done = requestDone {
                            done(RESULT_CODE_SUCCESS, "Request suceedded")
                            return
                        }
                    } else {
                        if let done = requestDone {
                            done(RESULT_CODE_FAILURE, "Server responded but request failed")
                            return
                        }
                    }
                } else {
                    if let done = requestDone {
                        done(RESULT_CODE_FAILURE, "Server did not respond or did not understand the paramters")
                        return
                    }
                }
            }
        
    }
}