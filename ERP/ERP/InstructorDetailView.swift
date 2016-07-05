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
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnRole: UIButton!
    @IBOutlet weak var btnClass: UIButton!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var vDetailContainer: UIView!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblName: UILabel!
    
    var classData : Variable<[String]> = Variable([])
    
    // MARK: Updated data
    var selectedClassCode : String?
    var selectedRoleCode : String?
    var selectedDate : NSDate?
    
    // Used to save the original frame of the detail view
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
    }
    
    override func layoutSubviews() {
        self.configUI()
    }
    
    func configUI() {
        self.btnClass.becomeRound()
        self.btnClass.layer.borderWidth = 1.0
        self.btnClass.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnRole.becomeRound()
        self.btnRole.layer.borderWidth = 1.0
        self.btnRole.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnCalendar.becomeRound()
        self.btnCalendar.layer.borderWidth = 1.0
        self.btnCalendar.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnCall.layer.cornerRadius = 10
        self.btnCall.layer.masksToBounds = true

    }
    
        
    // MARK: Update instructor info into view
    func viewInstructorInfo() {
        if let inst = self.instructor {
            LazyImage.showForImageView(imvAvatar, url: inst.imgUrl)
            self.lblName.text = inst.name
            self.lblPhoneNumber.text = inst.phone
            if inst.classes.count > 0 {
                //self.txfClass.text = inst.classes[0]
            }
            if inst.roles.count > 0 {
                //self.txfRole.text = inst.roles[0]
            }
        }

    }
    
    @IBAction func CallforEverybody(sender: AnyObject) {
        if let inst = self.instructor {
            let phone = "tel://"+inst.phone;
            let url:NSURL = NSURL(string:phone)!;
            UIApplication.sharedApplication().openURL(url);
            print(phone)
        }
    }
    
}
    
    



    

    


