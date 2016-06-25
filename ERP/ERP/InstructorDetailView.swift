//
//  InstructorDetailView.swift
//  ERP
//
//  Created by admin on 6/19/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class InstructorDetailView: UIView{
    
    // MARK: View references
    
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnRole: UIButton!
    @IBOutlet weak var btnClass: UIButton!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblIntructorName: UILabel!
    @IBOutlet weak var txfClass: UITextField!
    @IBOutlet weak var txfRole: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var vDetailContainer: UIView!
    
    var classData : Variable<[String]> = Variable([])
    // MARK: Pickers
    var pcvClass : UIPickerView!
    var pcvRole : UIPickerView!
    var dpvDate : UIDatePicker!
    
    // MARK: Updated data
    var selectedClassCode : String?
    var selectedRoleCode : String?
    var selectedDate : NSDate?
    
    // Used to save the original frame of the detail view
    var originalDetailFrame : CGRect!
    var rx_disposeBag = DisposeBag()
    var instructor : Instructor? {
        didSet {
            self.viewInstructorInfo()
        }
    }
    
    
    override func awakeFromNib() {
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let viewInfo = NSBundle.mainBundle().loadNibNamed("InstructorInfo", owner: self, options: nil)[0] as! UIView
        self.layoutIfNeeded()
        viewInfo.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(viewInfo)
        
        self.configUI()
    }
    
    func configUI() {
        self.btnFinish.layer.cornerRadius = self.btnFinish.frame.size.width/2
        self.btnClass.layer.cornerRadius = self.btnClass.frame.size.width/2
        self.btnRole.layer.cornerRadius = self.btnRole.frame.size.width/2
        self.btnCalendar.layer.cornerRadius = self.btnCalendar.frame.size.width/2
    }
    
        
    // MARK: Update instructor info into view
    func viewInstructorInfo() {
        if let inst = self.instructor {
            LazyImage.showForImageView(imvAvatar, url: inst.imgUrl)
            self.lblIntructorName.text = inst.name
            if inst.classes.count > 0 {
                //self.txfClass.text = inst.classes[0]
            }
            if inst.roles.count > 0 {
                //self.txfRole.text = inst.roles[0]
            }
        }

    }
}
    
    



    

    


