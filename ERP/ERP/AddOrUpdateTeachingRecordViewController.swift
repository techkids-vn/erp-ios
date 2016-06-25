//
//  InstructorDetailViewController.swift
//  ERP
//
//  Created by techkids on 6/15/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RealmSwift
import RxCocoa
import RxSwift

class AddOrUpdateTeachingRecordViewController: UIViewController {

    var instructor : Instructor?    

    @IBOutlet weak var vMaskView: UIView!

    @IBOutlet weak var vInstructorDetail: InstructorDetailView!
    @IBOutlet weak var btnDone: UIButton!
    
    var currentViewInMaskView : UIView?
    
    var rx_disposeBag = DisposeBag()
    @IBOutlet weak var btiDone: UIBarButtonItem!
    
    var pcvClass : UIPickerView!
    var pcvRole : UIPickerView!
    var dpvDate : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vInstructorDetail.instructor = self.instructor
        // Setup gestures
        let tapGesture = UITapGestureRecognizer()
        _ = tapGesture.rx_event.subscribeNext {
            tapGestureRecognizer in
            self.hideKeyboardWhenTappedAround()
        }.addDisposableTo(self.rx_disposeBag)
        
        self.navigationItem.rightBarButtonItem = self.btiDone
        
        self.btiDone.rx_tap.subscribeNext {
            self.vInstructorDetail.addOrUpdateTeachingRecord()
            self.navigationController?.popViewControllerAnimated(true)
        }.addDisposableTo(self.rx_disposeBag)
        
        self.view.addGestureRecognizer(tapGesture)
        self.choseStep()
    }
    
    func choseStep() {
        _ = vInstructorDetail.btnClass.rx_tap.subscribeNext {
            let view = NSBundle.mainBundle().loadNibNamed("ClassSelector", owner: self, options: nil)[0] as! ClassSelectorView
            view.instructor = self.instructor
            view.frame = self.vMaskView.bounds
            for v in self.vMaskView.subviews {
                v.removeFromSuperview()
            }
            self.vMaskView.addSubview(view)
            self.currentViewInMaskView = view
        }
        
        _ = vInstructorDetail.btnRole.rx_tap.subscribeNext {
            let view = NSBundle.mainBundle().loadNibNamed("RoleSelector", owner: self, options: nil)[0] as! RoleSelector
            view.instructor = self.instructor
            view.frame = self.vMaskView.bounds
            for v in self.vMaskView.subviews {
                v.removeFromSuperview()
            }
            self.vMaskView.addSubview(view)
            self.currentViewInMaskView = view
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dumpData() {
        
        let classRole1 = ClassRole.create("ios5", roleCode: "coach")
        let classRole2 = ClassRole.create("ios6", roleCode: "coach")
        let classRole3 = ClassRole.create("ios6", roleCode: "inst")
        let classRoles = List<ClassRole>()
        classRoles.append(classRole1)
        classRoles.append(classRole2)
        classRoles.append(classRole3)
        self.instructor = Instructor.create("http://i.imgur.com/mSCSREI.jpg?1", name: "Nguyen Son Vu", team: "iOS", code: "TEC0010", classRoles: classRoles)
    }
    
}
