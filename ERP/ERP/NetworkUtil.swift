//
//  NetworkUtil.swift
//  ERP
//
//  Created by admin on 6/20/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import ReachabilitySwift

class NetworkUtil {
    class var sharedReachability : Reachability {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : Reachability? = nil
        }
        
        dispatch_once(&Static.onceToken, {
            do {
                try! Static.instance = Reachability.reachabilityForInternetConnection()
            }
        })
        
        return Static.instance!;
    }
}
