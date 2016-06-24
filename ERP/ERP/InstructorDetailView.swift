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

class InstructorDetailView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: View references
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblInstructorName: UILabel!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var txfClass: UITextField!
    @IBOutlet weak var txfRole: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var vDetailContainer: UIView!
    
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
        self.setupAvatar()
        self.setUpPickerViewForTextFields()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed("InstructorDetailView", owner: self, options: nil)[0] as! UIView
        self.layoutIfNeeded()
        view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(view)
        
        // Store original location of detail view
        self.originalDetailFrame = self.vDetailContainer.frame
    }
    
    // MARK: Update instructor info into view
    func viewInstructorInfo() {
        if let inst = self.instructor {
            LazyImage.showForImageView(imvAvatar, url: inst.imgUrl)
            self.lblInstructorName.text = inst.name
            self.lblTeam.text = inst.team
            if inst.classes.count > 0 {
                self.txfClass.text = inst.classes[0]
            }
            if inst.roles.count > 0 {
                self.txfRole.text = inst.roles[0]
            }
        }
    }
    
    // MARK: Setup layout
    func setupAvatar() {
        self.imvAvatar.layer.cornerRadius = self.imvAvatar.frame.size.width/2
        self.imvAvatar.clipsToBounds = true
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
        }.addDisposableTo(self.rx_disposeBag)
        
        self.txfClass.inputView = self.pcvClass
        self.txfRole.inputView = self.pcvRole
        self.txfDate.inputView = self.dpvDate
        
        self.txfRole.delegate = self;
        self.txfClass.delegate = self;
        self.txfDate.delegate = self;
    }

    func donePicker(pickerView : UIBarButtonItem) {
        self.dismissKeyboard()
    }
    
    // MARK: PickerView delegate and datasource
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
    
    // MARK: Dismiss keyboard
    func dismissKeyboard() {
        self.txfRole.resignFirstResponder()
        self.txfClass.resignFirstResponder()
        self.txfDate.resignFirstResponder()
    }
    
    // MARK: Add or edit teaching record
    func addOrUpdateTeachingRecord() {
        if let classCode = self.selectedClassCode {
            if let roleCode = self.selectedRoleCode {
                if let date = self.selectedDate {
                    let instTeachingRecord = TeachingRecord.create(self.instructor!.code, classCode: classCode, roleCode: roleCode, date: date)
                    NetworkContext.postInstructorTeachingRecord(instTeachingRecord, requestDone: {
                        code, message in
                        print(message)
                    })
                }
            }
        }
    }
    
    // Not Needed
    
//    // MARK: Toolbars
//    func createToolbarWithDoneButton() -> UIToolbar {
//        let toolBar = UIToolbar()
//        
//        toolBar.barStyle = UIBarStyle.Default
//        toolBar.translucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(dismissKeyboard))
//        
//        toolBar.setItems([spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true
//        
//        return toolBar
//    }
    
    // MARK: TextField delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if let wnd = self.window {
            if let inputView = textField.inputView {
                /* Since the pickwerview does not belong to this view but the window, we have to convert the coordinate system to the window's, calculate the detailview frame and then convert it back to this view's coordinate */
                let detailRectInView = self.vDetailContainer.frame
                var detailRect = wnd.convertRect(detailRectInView, fromView: self)
                /*
                 |-----------------| -
                 |                 | y
                 |-----------------| -
                 |   DetailView    |
                 |                 |   ---> Window
                 |-----------------|
                 |    InputView    |
                 |                 |
                 |-----------------|
                 */
                detailRect.origin.y = wnd.bounds.size.height - inputView.bounds.size.height -  detailRectInView.height
                
                let detailRectInViewAfterConvert = wnd.convertRect(detailRect, toView: self)
                self.vDetailContainer.frame = detailRectInViewAfterConvert
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.vDetailContainer.frame = self.originalDetailFrame!
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
