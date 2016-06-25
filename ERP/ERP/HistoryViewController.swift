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
    
    
    
    var teachingRecordGroupsVar : Variable<[TeachingRecordGroup]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchTeachingRecords()
        self.initLayout()
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
    }
    
    func fetchTeachingRecords() {
        NetworkContext.fetchAllTeachingRecords( {
            teachingRecords in
            self.teachingRecordGroupsVar.value = TeachingRecord.groupByDate(teachingRecords)
            self.tbvHistory.reloadData()
        })
    }
    
    // MARK: TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.teachingRecordGroupsVar.value.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teachingRecordGroupsVar.value[section].teachingRecords!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TeachingRecordCell
        cell.teachingRecord = self.teachingRecordGroupsVar.value[indexPath.section].teachingRecords![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.teachingRecordGroupsVar.value[section].dateString
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.teachingRecordGroupsVar.value[indexPath.section].teachingRecords![indexPath.row].editable
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let alert = UIAlertController.init(title: "Delete teaching record", message: "Do you want to delete this record?", preferredStyle: UIAlertControllerStyle.Alert)
            let yesAction = UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in })
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
