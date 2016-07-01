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
    
    var classSelected : Variable<String> = Variable("")
    
    func layout() {
        classData.value = self.instructor.classes
    }
    
    override func awakeFromNib() {
        
        let cellNib =  UINib(nibName: "ClassCell", bundle: nil)
        self.tbvClass.registerNib(cellNib, forCellReuseIdentifier: "Cell")
        
        _ = classData.asObservable().bindTo(tbvClass.rx_itemsWithCellIdentifier("Cell", cellType: ClassCell.self)) {
            row, data, cell in
            cell.lblText!.text = data.firstCharacterUpperCase()
        }
        
        _ = self.tbvClass.rx_itemSelected.subscribeNext {
            indexPath in
            self.classSelected.value = self.classData.value[indexPath.row]
            print("\(self.classSelected )")
        }
            
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

}
