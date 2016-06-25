//
//  FinishSelectorView.swift
//  ERP
//
//  Created by Mr.Vu on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FinishSelectorView: UIView {
    
    @IBOutlet weak var btnSummit: UIButton!
    
    var submitFlag : Variable<String> = Variable("")
    
    override func awakeFromNib() {
       _ = self.btnSummit.rx_tap.subscribeNext {
            self.submitFlag.value = "submmit"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }


}
