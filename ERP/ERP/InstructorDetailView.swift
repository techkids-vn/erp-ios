//
//  InstructorDetailView.swift
//  ERP
//
//  Created by admin on 6/19/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class InstructorDetailView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed("InstructorDetailView", owner: self, options: nil)[0] as! UIView
        self.layoutIfNeeded()
        view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(view)
    }

}
