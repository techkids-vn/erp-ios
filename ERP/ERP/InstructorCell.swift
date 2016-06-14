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
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    var instructor : Instructor? {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        self.lblName.text = "Name: \(instructor!.name)"
        self.lblTeam.text = "Team: \(instructor!.team)"
        self.lblCode.text = "Code: \(instructor!.code)"
        LazyImage.showForImageView(self.imvAvatar, url: instructor?.imgUrl)
    }
}
