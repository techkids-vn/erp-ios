//
//  UIImageExtensions.swift
//  ERP
//
//  Created by admin on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func becomeRound() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
