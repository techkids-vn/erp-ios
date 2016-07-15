//
//  HIstoryViewController.swift
//  ERP
//
//  Created by admin on 6/22/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var vSearch: UIView!
    let aivWait = UIActivityIndicatorView(frame: CGRectMake(0,0,44,44))
    
    var teachingRecordGroups : [TeachingRecordGroup] = []
    var teachingRecordsVar : Variable<[TeachingRecord]> = Variable([])
    var teachingRecordBackUp = [TeachingRecord]()
    var rx_disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initLayout()
        self.followClickOnTableViewCell()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.fetchTeachingRecords()
        })
    }
    //MARK: hide keyboard
    func keyboardWillShow(notification: NSNotification) {
        self.hideKeyboardWhenTappedAround()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        for recognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
    }
    
    func followClickOnTableViewCell() {
        _ = self.tbvHistory.rx_itemSelected.subscribeNext {
            indexPath in
            let userName = self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row].userName
            if userName == DB.getUser()?.userName {
                let instructorClass = self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row].classCode
                let instructorCode = self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row].code
                let instructorRole = self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row].roleCode
                let date = self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row].date
                let teachingRecordId = self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row].recordId
                
                let instructorDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddOrUpdateTeachingRecord") as! AddOrUpdateTeachingRecordViewController
                instructorDetailVC.instructor = DB.getInstructorByCode(instructorCode)
                instructorDetailVC.instructorRole = instructorRole
                instructorDetailVC.instructrClass = instructorClass
                instructorDetailVC.dateUpdate = String(date)
                instructorDetailVC.isUpdate = true
                instructorDetailVC.teachingRecordId = teachingRecordId
                self.navigationController?.pushViewController(instructorDetailVC, animated: true)
            }
        }
        
    }
    
    func initLayout() {
        self.navigationItem.title = "History"
        self.navigationController?.navigationBar.translucent = false
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        //Activity Indicator
        self.aivWait.hidesWhenStopped = true
        self.aivWait.center = self.view.center
        self.view.addSubview(aivWait)
        self.aivWait.startAnimating()
        self.addLeftBarButtonWithImage(UIImage(named: "img-menu")!)
        
        // TableView
        self.tbvHistory.backgroundView = nil
        self.tbvHistory.dataSource = self
        self.tbvHistory.delegate = self
        self.tbvHistory.allowsMultipleSelectionDuringEditing = false
        self.tbvHistory.separatorColor = UIColor.grayColor()
        
        // Search bar
        self.vSearch.backgroundColor = CONTENT_BACKGROUND_COLOR
        self.vSearch.backgroundColor = UIColor.clearColor()
        
        
        _ = self.sbSearch
            .rx_text.throttle(0.3, scheduler: MainScheduler.instance)
            .subscribeNext { searchText in
                self.search(searchText)
            }.addDisposableTo(rx_disposeBag)
        
        
        _ = teachingRecordsVar.asObservable().subscribeNext {
            records in
            self.teachingRecordGroups = TeachingRecord.groupByDate(records)
            self.tbvHistory.reloadData()
        }
        
        // Background
        self.view.backgroundColor = HISTORY_BACKGROUND_COLOR
        
    }
    
    func fetchTeachingRecords() {
        NetworkContext.fetchAllTeachingRecords( {
            teachingRecords in
            self.teachingRecordsVar.value = teachingRecords
            self.teachingRecordBackUp = teachingRecords
            self.aivWait.stopAnimating()
        })
    }
    //MARK: Search
    func search(searchText : String) {
        if searchText == "" {
            self.teachingRecordsVar.value = self.teachingRecordBackUp
        }
        else {
            var searchPool = [TeachingRecord]()
            for teachingRecord in self.teachingRecordBackUp {
                let instructorName = String.convertUnicodeToASCII((teachingRecord.instructor?.name.lowercaseString)!)
                let searchString = String.convertUnicodeToASCII(searchText)
                //print(teachingRecord.code)
                if ( instructorName.containsString(searchString) || (teachingRecord.code.lowercaseString.containsString(searchText.lowercaseString))){
                    searchPool.append(teachingRecord)
                }
                self.teachingRecordsVar.value = searchPool
            }
        }
    }
    //MARK: Convert string 
//    func convert(string : String)->String?{
//        var newString = string.lowercaseString
//        newString = newString.stringByReplacingOccurrencesOfString("đ", withString: "d")
//        let data = newString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
//        newString = String.init(data: data!, encoding: NSASCIIStringEncoding)!
//               return newString
//    }
  
    
    // MARK: TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.teachingRecordGroups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teachingRecordGroups[section].teachingRecords!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TeachingRecordCell
        cell.teachingRecord = self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.teachingRecordGroups[section].dateString
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row].editable
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let alert = UIAlertController.init(title: "Delete teaching record", message: "Do you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
            let teachingRecord = self.self.teachingRecordGroups[indexPath.section].teachingRecords![indexPath.row]
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in
                let request = TeachingRecordRequest.create(teachingRecord, requestType: RequestType.DELETE)
                self.aivWait.startAnimating()
                NetworkContext.sendTeachingRecordRequest( request, requestDone: {
                    [weak self] code, message in
                    if code == NetworkContext.RESULT_CODE_SUCCESS {
                        self!.teachingRecordsVar.value.removeAtIndex((self?.teachingRecordsVar.value.indexOf{$0 == teachingRecord})!)
                    }
                    self!.aivWait.stopAnimating()
                    })
            })
            let noAction = UIAlertAction.init(title: "No", style: UIAlertActionStyle.Cancel, handler: {action in })
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
