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
    let imvIcon : String?
    let vcStoryBoardId : String?
    
    init(title: String, vcStoryBoardId: String, imvIcon: String) {
        self.title = title
        self.imvIcon = imvIcon
        self.vcStoryBoardId = vcStoryBoardId
    }
    
    static var MenuItems : [LeftMenuItem] {
        get {
            return [
                LeftMenuItem(title: "SEARCH INSTRUCTOR", vcStoryBoardId: "NavigationController", imvIcon: "img-search"),
                LeftMenuItem(title: "HISTORY", vcStoryBoardId: "NavigationControllerForHistory", imvIcon: "img-history"),
                LeftMenuItem(title: "LOGOUT", vcStoryBoardId: "", imvIcon: "img-logout")
            ]
        }
    }
}
