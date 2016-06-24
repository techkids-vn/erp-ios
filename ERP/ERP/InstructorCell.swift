//
//  InstructorCell.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class InstructorCell: UICollectionViewCell {

    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var attandanceView: UIView!
    var count = 0
    
    var instructor : Instructor? {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        self.lblName.text = "\(instructor!.name)"
        self.lblCode.text = "\(instructor!.code)"
        LazyImage.showForImageView(self.imvAvatar, url: instructor?.imgUrl)
        
        if count == 0 {
            let btnSize = 20
            let origiX = self.attandanceView.frame.size.width - CGFloat(btnSize+10)
//            let origiY = self.attandanceView.frame.size.height/2
            for index in 1...instructor!.recordCountToDay {
                let btnAttandance = UIButton(frame: CGRectMake(origiX - CGFloat(index*20),0,
                    20,20))
                btnAttandance.setImage(UIImage(named: "img-check"), forState: .Normal)
                self.attandanceView.addSubview(btnAttandance)
            }
            count = 1
        }

    }
}
