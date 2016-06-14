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

class SearchViewController: UIViewController {
    
    let INSTRUCTOR_API = "https://erp-dump.herokuapp.com/api/instructors"
    var instructors : Variable<[Instructor]> = Variable([])

    override func viewDidLoad() {
        self.setupUI()
        
        Alamofire.request(.GET, INSTRUCTOR_API)
            .validate()
            .responseJASON { response in
                if let json = response.result.value {
                    var instructors = [Instructor]()
//                    for item in Item(json[.items]).classes {
//                        print(item[0])
//                    }
                   
                    
                }
        }
    }
    
    func setupUI() {
        self.navigationItem.title = "INSTRUCTOR"
    }
}
