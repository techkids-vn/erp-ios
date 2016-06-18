//
//  SearchViewController.swift
//  ERP
//
//  Created by Mr.Vu on 6/13/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import JASON
import RealmSwift
import Foundation

class SearchViewController: UIViewController {
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var clvInstructor: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var vInstructors : Variable<[Instructor]> = Variable([])
    var instructorBackup = [Instructor]()
    var rx_disposeBag = DisposeBag()

    override func viewDidLoad() {
        self.configUI()
        self.getInstructor()
        self.configCollectionView()
        
        _ = self.searchBar
            .rx_text.throttle(0.3, scheduler: MainScheduler.instance)
            .subscribeNext { searchText in
                self.search(searchText)
        }.addDisposableTo(rx_disposeBag)
    }
    
    func configCollectionView() {
        _ = self.vInstructors.asObservable().bindTo(self.clvInstructor.rx_itemsWithCellIdentifier("InstructorCell", cellType: InstructorCell.self)){
            row,data,cell in
            cell.instructor = data
        }.addDisposableTo(rx_disposeBag)
    }
    
    func configUI() {
        self.navigationItem.title = "INSTRUCTOR LIST"
        self.waitIndicator.hidesWhenStopped = true
        self.waitIndicator.activityIndicatorViewStyle = .White
        self.waitIndicator.center = self.clvInstructor.center
        self.waitIndicator.startAnimating()
        self.configLayout()
    }
    
    func configLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width:  (self.view.frame.width - 30)/2, height: (self.clvInstructor.frame.width - 60)/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        self.clvInstructor.setCollectionViewLayout(layout, animated: true)
    }
    
    func getInstructor() {
        var instructors = [Instructor]()
        Alamofire.request(.GET, INSTRUCTOR_API)
            .validate()
            .responseJASON { response in
                if let json = response.result.value {
                    for dict in json[.items] {
                        let imgUrl = dict[.image]
                        let name = dict[.name]
                        let code = dict[.code]
                        let team = dict[.team]
                        let classes = dict[.classes]
                        
                        let classRoles = List<ClassRole>()
                        for c in classes {
                            let role = c["role"].stringValue
                            let code = c["code"].stringValue
                            classRoles.append(ClassRole.create(code, roleCode: role))
                        }
                        instructors.append(Instructor.create(imgUrl, name: name, team: team, code: code, classRoles: classRoles))
                    }
                    self.vInstructors.value = instructors
                    self.instructorBackup = instructors
                    self.waitIndicator.stopAnimating()
                }
        }
        
    }
    
    //MARK: Search
    func search(searchText : String) {
        if searchText == "" {
            self.vInstructors.value = self.instructorBackup
        }
        else {
            var searchPool = [Instructor]()
            for instructor in self.instructorBackup {
                let instructorName = instructor.name.lowercaseString
                if instructorName.containsString(searchText.lowercaseString) {
                    searchPool.append(instructor)
                }
                self.vInstructors.value = searchPool
            }
        }
    }
    
    
}
