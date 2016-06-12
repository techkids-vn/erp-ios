//
//  ViewController.swift
//  ERP
//
//  Created by admin on 6/12/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.login()
    }
    
    func setupUI() {
        self.btnLogin.layer.cornerRadius = 6.0
        self.txtUsername.text = "admin"
        self.txtPassword.text = "admin"
    }
    
    func login() {
        _ = self.btnLogin.rx_tap.subscribeNext {
            Login.create()
            print("xxx")
        }
    }

}

