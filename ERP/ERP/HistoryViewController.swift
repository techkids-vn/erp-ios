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

class HistoryViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var sbSearch: UISearchBar!
    
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
        
        // Search bar
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.teachingRecordGroupsVar.value.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teachingRecordGroupsVar.value[section].teachingRecords!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TeachingRecordCell
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.teachingRecordGroupsVar.value[section].dateString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
