//
//  RoleSelector.swift
//  ERP
//
//  Created by Mr.Vu on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RoleSelector: UIView {

    @IBOutlet weak var tbvRole: UITableView!
    var roleData : Variable<[String]> = Variable([])
    var instructor : Instructor! {
        didSet {
            self.layout()
        }
    }
    var roleSelected : Variable<String> = Variable("")
    
    func layout() {
        roleData.value = instructor.roles
    }
    
    override func awakeFromNib() {
        let cellNib =  UINib(nibName: "ClassCell", bundle: nil)
        self.tbvRole.registerNib(cellNib, forCellReuseIdentifier: "Cell")
        
        _ = roleData.asObservable().bindTo(tbvRole.rx_itemsWithCellIdentifier("Cell", cellType: ClassCell.self)) {
            row, data, cell in
            cell.lblText!.text = data
        }
        
        _ = tbvRole.rx_itemSelected.subscribeNext{
            indexPath in
            self.roleSelected.value = self.roleData.value[indexPath.row]
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
