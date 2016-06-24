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

class HistoryViewController: UIViewController {

    @IBOutlet weak var tbvHistory: UITableView!
    @IBOutlet weak var sbSearch: UISearchBar!
    
    var teachingRecordsDictVar : Variable<[String: TeachingRecord]> = Variable([:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchTeachingRecords()
        self.initLayout()
    }
    
    func initLayout() {
        // TableView
        self.tbvHistory.backgroundView = nil
        _ = self.teachingRecordsDictVar.asObservable().bindTo(self.tbvHistory.rx_itemsWithCellIdentifier("Cell", cellType: TeachingRecordCell.self)) {
            row, data, cell in
            
        }
        
        // Search bar
        self.sbSearch.tintColor = UIColor.clearColor()
        self.sbSearch.backgroundImage = UIImage()
    }
    
    func fetchTeachingRecords() {
        NetworkContext.fetchAllTeachingRecords( {
            teachingRecords in
            self.teachingRecordsDictVar.value = TeachingRecord.groupByDate(teachingRecords)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
