//
//  LeftMenuItem.swift
//  ERP
//
//  Created by admin on 6/23/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation

class LeftMenuItem: NSObject {
    let title : String?
    let vcStoryBoardId : String?
    
    init(title: String, vcStoryBoardId: String) {
        self.title = title
        self.vcStoryBoardId = vcStoryBoardId
    }
    
    static var MenuItems : [LeftMenuItem] {
        get {
            return [
                LeftMenuItem(title: "Search", vcStoryBoardId: "NavigationController"),
                LeftMenuItem(title: "History", vcStoryBoardId: "HistoryViewController")
            ]
        }
    }
}
