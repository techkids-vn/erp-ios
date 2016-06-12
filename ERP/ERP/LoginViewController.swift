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
            Login.checkLogin(self.txtUsername.text!, password: self.txtPassword.text!, requestDone: self.checkLogin)
            print("xxx")
        }
    }
    
    func checkLogin(statusLogin : Int) {
        if statusLogin == 1 {
            Login.create()
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
            self.presentViewController(vc, animated: false, completion: {

            })
        }
        else {
            let alert = UIAlertController(title: "", message: "Login Failed", preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction) in
            }
            alert.addAction(OKAction)
        }
    }

}

