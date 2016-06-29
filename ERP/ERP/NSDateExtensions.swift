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
    
    var fullString : String {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd, HH:mm"
        return formater.stringFromDate(self)
    }
    
    var dateString : String {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let dateString = formater.stringFromDate(self)
        let dateStringEndIndex = dateString.endIndex
        return dateString.substringFromIndex(dateStringEndIndex.advancedBy(-2))
    }
}

extension String {
    var date : NSDate {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.dateFromString(self)!
    }
    var fullDate : NSDate {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd, HH:mm"
        return formater.dateFromString(self)!
    }
    
}