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
import ReachabilitySwift

class SearchViewController: UIViewController {
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var clvInstructor: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var vSearch: UIView!
    
    var vInstructors : Variable<[Instructor]> = Variable([])
    var instructorBackup = [Instructor]()
    var rx_disposeBag = DisposeBag()
    var reachability : Reachability?
    
    override func viewDidLoad() {
        self.configUI()
        self.getInstructor()
        self.configCollectionView()
        print("xxxx \(DB.getAllTeachingRecordRequests())")
        _ = self.searchBar
            .rx_text.throttle(0.3, scheduler: MainScheduler.instance)
            .subscribeNext { searchText in
                self.search(searchText)
            }.addDisposableTo(rx_disposeBag)
    }
    
       //MARK: hide keyboard
    func keyboardWillShow(notification: NSNotification) {
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clvInstructor.reloadData()
        self.closeLeft()
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        for recognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
    }
    
    //MARK: config UI, UICollectionView
    func configCollectionView() {
        _ = self.vInstructors.asObservable()
            .bindTo(self.clvInstructor.rx_itemsWithCellIdentifier("InstructorCell", cellType: InstructorCell.self)){
                row,data,cell in
                cell.instructor = data
            }
            .addDisposableTo(rx_disposeBag)
        /* Get the selected instructor and open detail instructor view */
        self.clvInstructor.rx_itemSelected.subscribeNext {
            indexPath in
            let instructor = self.vInstructors.value[indexPath.row]
            let instructorDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddOrUpdateTeachingRecord") as! AddOrUpdateTeachingRecordViewController
            
            instructorDetailVC.instructor = instructor
            self.navigationController?.pushViewController(instructorDetailVC, animated: true);
            }
            .addDisposableTo(rx_disposeBag)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func configUI() {
        self.navigationItem.title = "INSTRUCTOR LIST"
        self.waitIndicator.hidesWhenStopped = true
        self.waitIndicator.activityIndicatorViewStyle = .White
        self.waitIndicator.center = self.clvInstructor.center
        self.waitIndicator.startAnimating()
        self.vSearch.backgroundColor = CONTENT_BACKGROUND_COLOR
        self.searchBar.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = CONTENT_BACKGROUND_COLOR
        self.navigationController?.navigationBar.translucent = false
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        self.configLayout()
    }
    
    func configLayout() {
        self.view.layoutIfNeeded()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let width = (self.view.frame.width - 25)/2
        layout.itemSize = CGSize(width:  width, height: 3*width/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        self.clvInstructor.setCollectionViewLayout(layout, animated: true)
        self.addLeftBarButtonWithImage(UIImage(named: "img-menu")!)
    }
    //MARK: - Get instructor
    func getInstructor() {
        do {
            reachability = try! Reachability.reachabilityForInternetConnection()
        }
        
        reachability!.whenReachable = {
            reachability in
            dispatch_async(dispatch_get_main_queue()){
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
                                let phone = dict[.contact][.phoneNumber]
                                
                                let classRoles = List<ClassRole>()
                                //print(classes)
                                for c in classes {
                                    let role = c["role"].stringValue
                                    let code = c["class_code"].stringValue
                                    classRoles.append(ClassRole.create(code, roleCode: role))
                                }
                                instructors.append(Instructor.create(imgUrl, name: name, team: team, code: code,phone: phone, classRoles: classRoles))
                            }
                            self.vInstructors.value = instructors
                            self.instructorBackup = instructors
                            self.waitIndicator.stopAnimating()
                        }
                }
            }
        }
        
        reachability!.whenUnreachable = {
            reachability in
            dispatch_async(dispatch_get_main_queue()) {
                let instructors = DB.getAllInstructors()
                self.vInstructors.value = instructors
                self.instructorBackup = instructors
                self.waitIndicator.stopAnimating()
            }
        }
        try! reachability?.startNotifier()
    }
    
    //MARK: Search
    func search(searchText : String) {
        if searchText == "" {
            self.vInstructors.value = self.instructorBackup
        }
        else {
            var searchPool = [Instructor]()
            for instructor in self.instructorBackup {
                let instructorName = String.convertUnicodeToASCII(instructor.name.lowercaseString)
                let instructCode = instructor.code.lowercaseString;
                let searchString = String.convertUnicodeToASCII(searchText)
                if (instructorName.containsString(searchString)||instructCode.containsString(searchString)) {
                    searchPool.append(instructor)
                }
                self.vInstructors.value = searchPool
            }
        }
    }
    
}
