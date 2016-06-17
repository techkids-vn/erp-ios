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

class InstructorDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var instructor : Instructor?
    var selectedClassCode : String?
    var selectedRoleCode : String?
    var selectedDate : NSDate?
    
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblInstructorName: UILabel!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var txfClass: UITextField!
    @IBOutlet weak var txfRole: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var aivWait: UIActivityIndicatorView!
    
    var pcvClass : UIPickerView!
    var pcvRole : UIPickerView!
    var dpvDate : UIDatePicker!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.dumpData()
        self.setupLayout()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout() {
        self.viewInstructorInfo()
        self.setUpPickerViewForTextFields()
        self.setupGestures()
        self.setupButtons()
        
        self.aivWait.hidesWhenStopped = true
    }
    
    // MARK: Setup layout
    func viewInstructorInfo() {
        if let inst = self.instructor {
            LazyImage.showForImageView(imvAvatar, url: inst.imgUrl)
            self.lblInstructorName.text = inst.name
            self.lblTeam.text = inst.team
        }
    }
    
    func setUpPickerViewForTextFields() {
        self.pcvClass = UIPickerView()
        self.pcvRole = UIPickerView()
        self.dpvDate = UIDatePicker()
        
        self.pcvClass.delegate = self
        self.pcvRole.delegate = self
        self.pcvClass.dataSource = self
        self.pcvRole.dataSource = self
        
        _ = self.dpvDate.rx_date.subscribeNext {
            date in
            self.selectedDate  = date
            self.txfDate.text = date.string
        }
        
        self.txfClass.inputView = self.pcvClass
        self.txfRole.inputView = self.pcvRole
        self.txfDate.inputView = self.dpvDate
    }
    
    func setupButtons() {
        _ = self.btnRecord.rx_tap.subscribeNext {
            if let classCode = self.selectedClassCode {
                if let roleCode = self.selectedRoleCode {
                    if let date = self.selectedDate {
                        self.aivWait.startAnimating()
                        let instTeachingRecord = InstructorTeachingRecord.create(self.instructor!.code, classCode: classCode, roleCode: roleCode, date: date)
                        NetworkContext.postInstructorTeachingRecord(instTeachingRecord, requestDone: {
                            code, message in
                            self.aivWait.stopAnimating()
                            print(message)
                        })
                    }
                }
            }
        }
    }

    // MARK: PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.pcvClass:
            return (self.instructor?.classes.count)!
        case self.pcvRole:
            return (self.instructor?.roles.count)!
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.pcvClass:
            return (self.instructor?.classes[row])
        case self.pcvRole:
            return (self.instructor?.roles[row])
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.pcvClass:
            self.selectedClassCode = self.instructor?.classes[row];
            self.txfClass.text = self.selectedClassCode
            break
        case self.pcvRole:
            self.selectedRoleCode = self.instructor?.roles[row];
            self.txfRole.text = self.selectedRoleCode
            break
        default: break
        }
    }
    
    // MARK: Gestures
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer()
        _ = tapGesture.rx_event.subscribeNext {
            tapGestureRecognizer in
            self.txfRole.resignFirstResponder()
            self.txfClass.resignFirstResponder()
            self.txfDate.resignFirstResponder()
        }
        self.view.addGestureRecognizer(tapGesture)
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
