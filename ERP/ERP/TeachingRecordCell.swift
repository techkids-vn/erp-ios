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
    
    var teachingRecord : TeachingRecord? {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        if let teachingRecord = self.teachingRecord {
            self.lblInstructorName.text = teachingRecord.code
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
