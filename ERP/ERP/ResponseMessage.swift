//
//  ResponseMessage.swift
//  ERP
//
//  Created by admin on 6/16/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import JASON

class ResponseMessage {
    let resultCode : Int?
    let resultMesage : String?
    
    static let RESULT_CODE_FAILURE = 0
    static let RESULT_CODE_SUCESS = 1
    
    
    init(resultCode : Int, resultMessage : String) {
        self.resultCode = resultCode
        self.resultMesage = resultMessage
    }
    
    init(json : JSON) {
        self.resultCode = json[.resultCode]
        self.resultMesage = json[.resultMessage]
    }
    
    var isSuccess : Bool {
        get {
            return self.resultCode! == ResponseMessage.RESULT_CODE_SUCESS
        }
    }
}
