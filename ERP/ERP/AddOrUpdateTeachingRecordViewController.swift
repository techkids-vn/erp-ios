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
    var instructrClass = ""
    var instructorRole = ""
    var dateUpdate = ""
    var teachingRecordId = ""
    var isUpdate = false
    
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var vMaskView: UIView!
    @IBOutlet weak var vInstructorDetail: InstructorDetailView!
    
    var currentViewInMaskView : UIView?
    var rx_disposeBag = DisposeBag()
    
    var classSelected   : Variable<String> = Variable("")
    var roleSelected    : Variable<String> = Variable("")
    var timeSelector    : Variable<String> = Variable("")
    var submitSelector  : Variable<String> = Variable("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInfoFromHistory()
        
        //        self.waitIndicator.hidesWhenStopped = true
        //        self.waitIndicator.activityIndicatorViewStyle = .White
        
        self.vInstructorDetail.instructor = self.instructor
        // Setup gestures
        let tapGesture = UITapGestureRecognizer()
        _ = tapGesture.rx_event.subscribeNext {
            tapGestureRecognizer in
            self.hideKeyboardWhenTappedAround()
            }.addDisposableTo(self.rx_disposeBag)
        
        self.view.addGestureRecognizer(tapGesture)
        self.loadClass()
        self.choseStep()
        self.nextStep()
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
        
    }
    
    func loadInfoFromHistory() {
        if self.isUpdate {
            self.vInstructorDetail.lblClass.text = self.instructrClass
            self.vInstructorDetail.lblRole.text = self.instructorRole
            self.vInstructorDetail.lblDate.text = self.dateUpdate
            
            self.vInstructorDetail.btnRole.backgroundColor = UIColor(netHex: 0xF29B34)
            self.vInstructorDetail.btnRole.userInteractionEnabled = true
            
            self.vInstructorDetail.btnClass.backgroundColor = UIColor(netHex: 0x71BA51)
            self.vInstructorDetail.btnClass.userInteractionEnabled = true
            
            self.vInstructorDetail.btnCalendar.backgroundColor = UIColor(netHex: 0xF29B34)
            self.vInstructorDetail.btnCalendar.userInteractionEnabled = true
        }
        else{
            self.vInstructorDetail.btnRole.backgroundColor = UIColor.grayColor()
            self.vInstructorDetail.btnRole.userInteractionEnabled = false
            self.vInstructorDetail.btnCalendar.backgroundColor = UIColor.grayColor()
            self.vInstructorDetail.btnCalendar.userInteractionEnabled = false
        }
    }
    
    func nextStep() {
        _ = self.classSelected.asObservable().subscribeNext {
            classSelect in
            if classSelect != "" {
                self.loadRole()
                self.vInstructorDetail.lblClass.text = classSelect
                self.vInstructorDetail.btnRole.backgroundColor = UIColor(netHex: 0x71BA51)
                self.vInstructorDetail.btnRole.userInteractionEnabled = true
                self.vInstructorDetail.btnClass.backgroundColor = UIColor(netHex: 0xF29B34)
            }
        }
        
        _ = self.roleSelected.asObservable().subscribeNext {
            role in
            if role != "" {
                self.loadCalendar()
                self.vInstructorDetail.lblRole.text = role
                self.vInstructorDetail.btnCalendar.backgroundColor = UIColor(netHex: 0x71BA51)
                self.vInstructorDetail.btnCalendar.userInteractionEnabled = true
                self.vInstructorDetail.btnRole.backgroundColor = UIColor(netHex: 0xF29B34)
                
            }
        }
        
        _ = self.timeSelector.asObservable().subscribeNext {
            date in
            if date != "" {
                self.vInstructorDetail.lblDate.text = date
            }
            else {
                self.vInstructorDetail.lblDate.text = NSDate.init(timeIntervalSinceNow:0).string
            }
        }
        
        _ = self.submitSelector.asObservable().subscribeNext {
            submit in
            //self.waitIndicator.startAnimating()
            if submit != "" {
                if !self.isUpdate {
                    self.requestDataToServer(self.classSelected.value, roleCode: self.roleSelected.value, time: self.timeSelector.value, requestType: RequestType.CREATE)
                }
                else {
                    self.requestDataToServer(self.classSelected.value, roleCode: self.roleSelected.value, time: self.timeSelector.value, requestType: RequestType.UPDATE)
                }
            }
        }
    }
    
    func requestDataToServer(classCode: String, roleCode : String, time : String, requestType : RequestType) {
        let today = NSDate();
        let dateFormatter = NSDateFormatter()
        //To prevent displaying either date or time, set the desired style to NoStyle.
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
        dateFormatter.timeZone = NSTimeZone()
        let localDate = dateFormatter.stringFromDate(today)
        
        var date : NSDate!
        if time == "" {
            date = today
        }
        else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.dateFromString(time)!
        }
        var record : TeachingRecord!
        if requestType == RequestType.CREATE {
             record = TeachingRecord.create(self.instructor!.code, classCode: classCode, roleCode: roleCode, date: date,recordTime: localDate)
        }
        else if requestType == RequestType.UPDATE {
            let userName = DB.getUser()?.userName
            record = TeachingRecord.create(self.instructor!.code, classCode: classCode, roleCode: roleCode, date: date,recordTime:localDate, recordId: self.teachingRecordId, userName: userName!)
        }
        
        let request = TeachingRecordRequest.create(record, requestType: requestType)
        NetworkContext.sendTeachingRecordRequest(request, requestDone: {
            code, message in
            
            if code == NetworkContext.RESULT_CODE_SUCCESS {
                //                self.waitIndicator.stopAnimating()
                let alert = UIAlertView(title: "", message: "Record Successfully", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            }
            else {
                //    self.waitIndicator.stopAnimating()
                let alert = UIAlertView(title: "", message: "Record Fail", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
        })
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
            self.configButtonColor(self.vInstructorDetail.btnClass,
                otherButton1: self.vInstructorDetail.btnRole,
                otherButton2: self.vInstructorDetail.btnCalendar)
            
        }
        
        _ = vInstructorDetail.btnRole.rx_tap.subscribeNext {
            self.loadRole()
            self.configButtonColor(self.vInstructorDetail.btnRole,
                otherButton1: self.vInstructorDetail.btnClass,
                otherButton2: self.vInstructorDetail.btnCalendar)
        }
        
        _ = vInstructorDetail.btnCalendar.rx_tap.subscribeNext {
            self.loadCalendar()
            self.configButtonColor(self.vInstructorDetail.btnCalendar,
                otherButton1: self.vInstructorDetail.btnRole,
                otherButton2: self.vInstructorDetail.btnClass)
        }
        
    }
    
    func configButtonColor(selectedButton : UIButton, otherButton1 : UIButton, otherButton2 : UIButton) {
        selectedButton.backgroundColor = UIColor(netHex: 0x71BA51)
        if otherButton1.userInteractionEnabled {
            otherButton1.backgroundColor = UIColor(netHex: 0xF29B34)
        }
        else {
            otherButton1.backgroundColor = UIColor.grayColor()
        }
        if otherButton2.userInteractionEnabled {
            otherButton2.backgroundColor = UIColor(netHex: 0xF29B34)
        }
        else {
            otherButton2.backgroundColor = UIColor.grayColor()
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
