//
//  InstructorCell.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class InstructorCell: UICollectionViewCell {

    @IBOutlet weak var numberCheck: UILabel!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var attandanceView: UIView!
        
    var instructor : Instructor? {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        self.lblName.text = "\(instructor!.name)"
        self.lblCode.text = "\(instructor!.code)"
        self.numberCheck.text = "\(instructor!.recordCountToDay)"
        LazyImage.showForImageView(self.imvAvatar, url: instructor?.imgUrl)
    }
}
