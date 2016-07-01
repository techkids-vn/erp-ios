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
}