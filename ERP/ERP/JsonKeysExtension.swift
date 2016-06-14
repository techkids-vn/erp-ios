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
    static let image   = JSONKey<String>("image")
    static let name    = JSONKey<String>("name")
    static let items    = JSONKey<JSON>("items")
}
