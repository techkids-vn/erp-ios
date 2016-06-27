//
//  LeftMenuCell.swift
//  ERP
//
//  Created by admin on 6/23/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imvIcon: UIImageView!
    
    var menuItem : LeftMenuItem? {
        didSet  {
            self.layout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func layout() {
        if let menuItem = self.menuItem {
            self.lblTitle.text = menuItem.title
            self.imvIcon.image = UIImage(named: menuItem.imvIcon!)
        }
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
