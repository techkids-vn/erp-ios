//
//  TeachingRecordGroup.swift
//  ERP
//
//  Created by admin on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation

class TeachingRecordGroup: NSObject {
    let dateString : String?
    var teachingRecords : [TeachingRecord]?
    
    init(dateString: String, teachingRecords: [TeachingRecord]) {
        self.dateString = dateString
        self.teachingRecords = teachingRecords
    }
}
