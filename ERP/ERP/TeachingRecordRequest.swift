//
//  RecordRequest.swift
//  ERP
//
//  Created by admin on 6/24/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import RealmSwift

enum RequestStatus : Int {
    case NOT_SENT
    case SENT_AND_FAILED //for debugging only
    case SENT_AND_SUCCEDED
}

enum RequestType : Int {
    case CREATE
    case UPDATE
    case DELETE
}

class TeachingRecordRequest : Object {
    
    dynamic var record: TeachingRecord?
    
    var requestType = RequestType.CREATE
    var status = RequestStatus.NOT_SENT
    
    static func create(record: TeachingRecord, requestType : RequestType) -> TeachingRecordRequest {
        let request = TeachingRecordRequest()
        request.record = record
        request.requestType = requestType
        request.status = RequestStatus.NOT_SENT
        DB.addTeachingRecordRequest(request)
        return request
    }
}

