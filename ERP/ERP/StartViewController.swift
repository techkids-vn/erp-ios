//
//  StartViewController.swift
//  ERP
//
//  Created by Mr.Vu on 6/13/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if DB.getLogin()?.didLogin == 1 {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
                self.presentViewController(vc, animated: false, completion: {
                    
                })
            }
            else {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                self.presentViewController(vc, animated: false, completion: {
                    
                })
            }
            
        }
    }

}
