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
    
    var instructor : Instructor? {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        self.lblName.text = "Name: \(instructor!.name)"
        self.lblCode.text = "Code: \(instructor!.code)"
        self.imvAvatar.layer.cornerRadius = self.imvAvatar.frame.width/2
        LazyImage.showForImageView(self.imvAvatar, url: instructor?.imgUrl)
    }
}
