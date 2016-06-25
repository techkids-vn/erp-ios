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

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var vSearch: UIView!
    @IBOutlet weak var aivWait: UIActivityIndicatorView!

    var teachingRecordGroups : [TeachingRecordGroup] = []
    var teachingRecordsVar : Variable<[TeachingRecord]> = Variable([])
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.fetchTeachingRecords()
    }
    
    func initLayout() {
        // TableView
        self.tbvHistory.backgroundView = nil
        self.tbvHistory.dataSource = self
        self.tbvHistory.delegate = self
        self.tbvHistory.allowsMultipleSelectionDuringEditing = false
        self.tbvHistory.separatorColor = UIColor.grayColor()
        
        // Search bar
        self.vSearch.backgroundColor = UIColor(netHex: 0x27ae60)
        self.sbSearch.tintColor = UIColor.clearColor()
        self.sbSearch.backgroundImage = UIImage()
        
        _ = teachingRecordsVar.asObservable().subscribeNext {
            records in
            self.teachingRecordGroups = TeachingRecord.groupByDate(records)
            self.tbvHistory.reloadData()
        }
    }
    
    func fetchTeachingRecords() {
        NetworkContext.fetchAllTeachingRecords( {
            teachingRecords in
            self.teachingRecordsVar.value = teachingRecords
        })
    }
    
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
                        self!.teachingRecordsVar.value.removeAtIndex(self!.teachingRecordsVar.value.indexOf(teachingRecord)!)
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
