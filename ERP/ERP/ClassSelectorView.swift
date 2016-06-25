//
//  ClassSelectorView.swift
//  ERP
//
//  Created by Mr.Vu on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ClassSelectorView: UIView {

    @IBOutlet weak var tbvClass: UITableView!
    var classData : Variable<[String]> = Variable([])
    var instructor : Instructor! {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        classData.value = self.instructor.classes
    }
    
    override func awakeFromNib() {
        let cellNib =  UINib(nibName: "ClassCell", bundle: nil)
        self.tbvClass.registerNib(cellNib, forCellReuseIdentifier: "Cell")
        
        _ = classData.asObservable().bindTo(tbvClass.rx_itemsWithCellIdentifier("Cell", cellType: ClassCell.self)) {
            row, data, cell in
            cell.lblText!.text = data
        }
            
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

}
