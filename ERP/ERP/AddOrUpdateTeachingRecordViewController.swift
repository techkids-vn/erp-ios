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

class AddOrUpdateTeachingRecordViewController: UIViewController, UIAlertViewDelegate {

    var instructor : Instructor?    

    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var vMaskView: UIView!
    @IBOutlet weak var vInstructorDetail: InstructorDetailView!
    
    var currentViewInMaskView : UIView?
    
    var rx_disposeBag = DisposeBag()    
    
    var classSelected : Variable<String> = Variable("")
    var roleSelected : Variable<String> = Variable("")
    var timeSelector : Variable<String> = Variable("")
    var submitSelector : Variable<String> = Variable("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.waitIndicator.hidesWhenStopped = true
        self.vInstructorDetail.instructor = self.instructor
        // Setup gestures
        let tapGesture = UITapGestureRecognizer()
        _ = tapGesture.rx_event.subscribeNext {
            tapGestureRecognizer in
            self.hideKeyboardWhenTappedAround()
        }.addDisposableTo(self.rx_disposeBag)
        
        self.configButtonAtFirst()
        self.loadClass()
        self.view.addGestureRecognizer(tapGesture)
        self.choseStep()
        self.nextStep()
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
    }
    
    func nextStep() {
        _ = self.classSelected.asObservable().subscribeNext {
            classSelect in
            if classSelect != "" {
                self.loadRole()
                self.vInstructorDetail.btnRole.backgroundColor = UIColor(netHex: 0x008040)
                self.vInstructorDetail.btnRole.userInteractionEnabled = true
                
                self.vInstructorDetail.btnCalendar.backgroundColor = UIColor.grayColor()
                self.vInstructorDetail.btnCalendar.userInteractionEnabled = false

            }
        }
        
        _ = self.roleSelected.asObservable().subscribeNext {
            role in
            if role != "" {
                self.loadCalendar()
                self.vInstructorDetail.btnRole.backgroundColor = UIColor(netHex: 0x008040)
                self.vInstructorDetail.btnRole.userInteractionEnabled = true
                
                self.vInstructorDetail.btnCalendar.backgroundColor = UIColor(netHex: 0x008040)
                self.vInstructorDetail.btnCalendar.userInteractionEnabled = true
                
            }
        }
        
        _ = self.timeSelector.asObservable().subscribeNext {
            time in
            if time != "" {
                self.vInstructorDetail.btnRole.backgroundColor = UIColor(netHex: 0x008040)
                self.vInstructorDetail.btnRole.userInteractionEnabled = true
                
                self.vInstructorDetail.btnCalendar.backgroundColor = UIColor(netHex: 0x008040)
                self.vInstructorDetail.btnCalendar.userInteractionEnabled = true

            }
        }
        
        _ = self.submitSelector.asObservable().subscribeNext {
            submit in
            if submit != "" {
                self.requestDataToServer(self.classSelected.value, roleCode: self.roleSelected.value, time: self.timeSelector.value)
            }
        }
    }
    
    func requestDataToServer(classCode: String, roleCode : String, time : String) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date : NSDate!
        if time == "" {
            date = NSDate.init(timeIntervalSince1970: 0)
        }
        else {
             date = dateFormatter.dateFromString(time)!
        }
        let record = TeachingRecord.create(self.instructor!.code, classCode: classCode, roleCode: roleCode, date: date)
        let request = TeachingRecordRequest.create(record, requestType: RequestType.CREATE)
        NetworkContext.sendTeachingRecordRequest(request, requestDone: {
            code, message in
            
            if message.containsString("Requested sucessfully") {
                let alert = UIAlertView(title: "", message: "Record Successfully", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            }
            else {
                let alert = UIAlertView(title: "", message: "Record Successfully", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
        })
    }
    
    func configButtonAtFirst() {
        self.vInstructorDetail.btnRole.backgroundColor = UIColor.grayColor()
        self.vInstructorDetail.btnRole.userInteractionEnabled = false
        
        self.vInstructorDetail.btnCalendar.backgroundColor = UIColor.grayColor()
        self.vInstructorDetail.btnCalendar.userInteractionEnabled = false
        
    }
 
    func loadClass() {
        let view = NSBundle.mainBundle().loadNibNamed("ClassSelector", owner: self, options: nil)[0] as! ClassSelectorView
        view.instructor = self.instructor
        view.frame = self.vMaskView.bounds
        for v in self.vMaskView.subviews {
            v.removeFromSuperview()
        }
        view.classSelected = self.classSelected
        self.vMaskView.addSubview(view)
        self.currentViewInMaskView = view
    }
    
    func loadRole() {
        let view = NSBundle.mainBundle().loadNibNamed("RoleSelector", owner: self, options: nil)[0] as! RoleSelector
        view.instructor = self.instructor
        view.frame = self.vMaskView.bounds
        for v in self.vMaskView.subviews {
            v.removeFromSuperview()
        }
        view.roleSelected = self.roleSelected
        self.vMaskView.addSubview(view)
        self.currentViewInMaskView = view
    }
    
    func loadCalendar() {
        let view = NSBundle.mainBundle().loadNibNamed("CalendarSelectorView", owner: self, options: nil)[0] as! CalendarSelectorView

        view.frame = self.vMaskView.bounds
        for v in self.vMaskView.subviews {
            v.removeFromSuperview()
        }
        view.time = self.timeSelector
        view.submitFlag = self.submitSelector
        self.vMaskView.addSubview(view)
        self.currentViewInMaskView = view
    }
    
    func choseStep() {
        _ = vInstructorDetail.btnClass.rx_tap.subscribeNext {
            self.loadClass()
        }
        
        _ = vInstructorDetail.btnRole.rx_tap.subscribeNext {
            self.loadRole()
        }
        
        _ = vInstructorDetail.btnCalendar.rx_tap.subscribeNext {
            self.loadCalendar()
        }

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIAlertView Delegate
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.navigationController?.popViewControllerAnimated(true)
        }
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
