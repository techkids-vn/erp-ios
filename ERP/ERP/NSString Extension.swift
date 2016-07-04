//
//  NSString Extension.swift
//  ERP
//
//  Created by Mr.Vu on 7/1/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation

extension String {
    func firstCharacterUpperCase() -> String {
        let lowercaseString = self.lowercaseString
        
        return lowercaseString.stringByReplacingCharactersInRange(lowercaseString.startIndex...lowercaseString.startIndex, withString: String(lowercaseString[lowercaseString.startIndex]).uppercaseString)
    }
    
    static func convertUnicodeToASCII(s:String) -> String{
        var newString:String = s.lowercaseString
        newString = newString.stringByReplacingOccurrencesOfString("đ", withString: "d")
        let data = newString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        newString = String.init(data: data!, encoding: NSASCIIStringEncoding)!
        return newString
    }
}