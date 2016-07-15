//
//  TeachingRecordCell.swift
//  ERP
//
//  Created by admin on 6/24/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class TeachingRecordCell: UITableViewCell {
    
    @IBOutlet weak var lblInstructorName: UILabel!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblRoleName: UILabel!
    @IBOutlet weak var vRoot: UIView!
    @IBOutlet weak var lblRecordTime: UILabel!
    
    var teachingRecord : TeachingRecord? {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        if let teachingRecord = self.teachingRecord {
            if let instructor = teachingRecord.instructor {
                self.lblInstructorName.text = instructor.name
                self.lblClassName.text = teachingRecord.classTitle
                self.lblRoleName.text = teachingRecord.roleTitle
                self.lblRecordTime.text = teachingRecord.recordTime
                LazyImage.showForImageView(self.imvAvatar, url: instructor.imgUrl)
                self.imvAvatar.layer.cornerRadius = self.imvAvatar.frame.width/2
                self.imvAvatar.layer.borderWidth = 1.0
                self.imvAvatar.layer.borderColor = UIColor.blackColor().CGColor
            }
            if teachingRecord.editable {
                vRoot.backgroundColor = HISTORY_BACKGROUND_COLOR
            } else {
                vRoot.backgroundColor = UIColor.init(netHex: 0x7f8c8d)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imvAvatar.layoutIfNeeded()
        self.imvAvatar.becomeRound()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
