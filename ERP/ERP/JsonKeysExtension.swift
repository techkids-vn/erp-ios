//
//  JsonKeysExtension.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import JASON

extension JSONKeys {
    static let team    = JSONKey<String>("team")
    static let classes = JSONKey<JSON>("classes")
    static let role    = JSONKey<[NSArray]>("role")
    static let code    = JSONKey<String>("code")
    static let title    = JSONKey<String>("title")
    static let image   = JSONKey<String>("image")
    static let name    = JSONKey<String>("name")
    static let items    = JSONKey<JSON>("items")
    static let resultCode = JSONKey<Int>("result_code")
    static let resultMessage = JSONKey<String>("result_message")
    static let recordId = JSONKey<String>("record_id")
    static let instructorCode = JSONKey<String>("instructor_code")
    static let roleCode = JSONKey<String>("role_code")
    static let classCode = JSONKey<String>("class_code")
    static let date = JSONKey<String>("date")
    static let userName = JSONKey<String>("user_name")
    static let id = JSONKey<String>("_id")
    static let _id = JSONKey<String>("_id")
    static let recordTime = JSONKey<String>("record_time")
    //    static let oid = JSONKey<String>("$oid")
}
