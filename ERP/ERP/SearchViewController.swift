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

class SearchViewController: UIViewController {
    @IBOutlet weak var clvInstructor: UICollectionView!
    
    var instructors : Variable<[Instructor]> = Variable([])

    override func viewDidLoad() {
        self.setupUI()
        self.getInstructor()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        _ = self.instructors.asObservable().bindTo(self.clvInstructor.rx_itemsWithCellIdentifier("InstructorCell", cellType: InstructorCell.self)){
            row,data,cell in
            cell.instructor = data
        }
    }
    
    func setupUI() {
        self.navigationItem.title = "INSTRUCTOR"
        self.setupLayout()
    }
    
    func setupLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width:  (self.view.frame.width - 30)/2, height: (self.clvInstructor.frame.width - 60)/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        self.clvInstructor.setCollectionViewLayout(layout, animated: true)
    }
    
    func getInstructor() {
        Alamofire.request(.GET, INSTRUCTOR_API)
            .validate()
            .responseJASON { response in
                if let json = response.result.value {
                    var instructors = [Instructor]()
                    
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
                    self.instructors.value = instructors
                }
                
        }
    }
}
