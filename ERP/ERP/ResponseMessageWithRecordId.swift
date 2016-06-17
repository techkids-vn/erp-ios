//
//  ResponseMessageWithRecordId.swift
//  ERP
//
//  Created by admin on 6/17/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import JASON

class ResponseMessageWithRecordId: ResponseMessage {
    let recordId : Int?
    
    override init(json: JSON) {
        self.recordId = json[.recordId]
        super.init(json: json)
    }
    
    init(resultCode: Int, resultMessage: String, recordId : Int) {
        self.recordId = recordId
        super.init(resultCode: resultCode, resultMessage: resultMessage)
    }
}
