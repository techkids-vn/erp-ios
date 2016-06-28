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
    let recordId : String?
    
    override init(json: JSON) {
        self.recordId = json[._id]
        super.init(json: json)
    }
    
    init(resultCode: Int, resultMessage: String, recordId : String) {
        self.recordId = recordId
        super.init(resultCode: resultCode, resultMessage: resultMessage)
    }
}
