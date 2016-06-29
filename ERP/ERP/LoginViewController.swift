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
import SlideMenuControllerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.login()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        self.setupUI()
    }
    
    func setupUI() {
        self.imvIcon.layer.cornerRadius = self.imvIcon.frame.width/2
        self.imvIcon.layer.shadowColor = UIColor.blackColor().CGColor;
        self.imvIcon.layer.shadowOffset = CGSizeMake(0, 1);
        self.imvIcon.layer.shadowOpacity = 1;
        self.imvIcon.layer.shadowRadius = 1.0;
        self.imvIcon.clipsToBounds = false;
        self.btnLogin.layer.cornerRadius = 6.0
        self.txtUsername.text = "admin"
        self.txtPassword.text = "111111"
        self.waitIndicator.hidesWhenStopped = true
        self.waitIndicator.activityIndicatorViewStyle = .Gray
    }
    
    func login() {
        _ = self.btnLogin.rx_tap.subscribeNext {
            User.checkLogin(self.txtUsername.text!, password: self.txtPassword.text!,
                requestDone: self.checkLogin)
            self.waitIndicator.startAnimating()
        }
    }
    
    func checkLogin(statusLogin : Int, message: String) {
        self.waitIndicator.stopAnimating()
        if message.containsString("OK") {
            if DB.getUserByName(self.txtUsername.text!)?.userName == self.txtUsername.text!  {
                DB.login(DB.getUserByName(self.txtUsername.text!)!)
            }
            else {
                User.create(self.txtUsername.text!, password: self.txtPassword.text!)
            }
            let leftVC = self.storyboard!.instantiateViewControllerWithIdentifier("LeftViewController")            
            let navVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationController")
                as! NavigationController
            let slideVC = SlideMenuController(mainViewController: navVC, leftMenuViewController: leftVC)
            self.view.window!.rootViewController = slideVC
        }
        else {
            let alertView = UIAlertView(title: "", message: "Login Failed", delegate: nil,
                                        cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
}


