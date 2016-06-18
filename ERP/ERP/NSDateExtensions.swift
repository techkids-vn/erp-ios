//
//  NSDateFormaterExtensions.swift
//  ERP
//
//  Created by admin on 6/17/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation

extension NSDate {
    var string : String {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.stringFromDate(self)
    }
}