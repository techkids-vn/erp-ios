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
    
    var teachingRecordDict : Variable<[String: TeachingRecord]> = Variable([:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initLayout()
    }
    
    func initLayout() {
        // TableView
        self.tbvHistory.backgroundView = nil
        
        // Search bar
        self.sbSearch.tintColor = UIColor.clearColor()
        self.sbSearch.backgroundImage = UIImage()
    }
    
    func downloadHistoryRecords() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
