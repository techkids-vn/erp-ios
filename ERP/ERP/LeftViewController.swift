//
//  LeftViewController.swift
//  ERP
//
//  Created by admin on 6/23/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class LeftViewController: UIViewController, UIAlertViewDelegate {

    
    @IBOutlet weak var imvLogo: UIImageView!
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var tbvMenu: UITableView!
    
    var menuItemsVar : Variable<[LeftMenuItem]> = Variable([])
    var rx_disosebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initData()
        self.initLayout()
    }
    
    func initData() {
        self.menuItemsVar.value = LeftMenuItem.MenuItems
    }
    
    func initLayout() {
        self.view.layoutIfNeeded()
        self.imvLogo.layoutIfNeeded()
        self.imvLogo.layer.cornerRadius = self.imvLogo.frame.size.width / 2;
        self.imvLogo.layer.shadowColor = UIColor.blackColor().CGColor
        self.imvLogo.layer.shadowOpacity = 0.8
        self.imvLogo.layer.shadowOffset = CGSizeZero
        self.imvLogo.layer.shadowRadius = 10
        
        self.imvLogo.clipsToBounds = true
        self.tbvMenu.separatorStyle = .None
        self.view.backgroundColor = UIColor(netHex: 0xf7f7f7)
         _ = self.menuItemsVar.asObservable().bindTo(self.tbvMenu.rx_itemsWithCellIdentifier("Cell", cellType: LeftMenuCell.self)) {
            row, data, cell in
            cell.menuItem = data
        }.addDisposableTo(self.rx_disosebag)

        _ = self.tbvMenu.rx_itemSelected.subscribeNext {
            indexPath in
            if self.menuItemsVar.value[indexPath.row].title == "Logout" {
                let alertView = UIAlertView(title: "", message: "Do you want to logout?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                alertView.show() 
            }
            else {
                let menuItem = self.menuItemsVar.value[indexPath.row]
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier(menuItem.vcStoryBoardId!)
                self.slideMenuController()?.changeMainViewController(vc!, close: true)
            }
            self.tbvMenu.deselectRowAtIndexPath(indexPath, animated: false)
        }.addDisposableTo(self.rx_disosebag)
    }
    
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIAlertView delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
//            self.closeLeft()
        }
        else if buttonIndex == 1 {
            let screen = UIScreen.mainScreen().bounds
            let waitIndicator = UIActivityIndicatorView(frame: CGRectMake(screen.width/2,screen.height/2,30,30))
            waitIndicator.activityIndicatorViewStyle = .Gray
            //self.view.addSubview(waitIndicator)
            waitIndicator.startAnimating()
           
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                 self.logout()
            })
        }
    }
    
    func logout() {
        Alamofire.request(.GET,LOGOUT_API)
            .validate()
            .responseJASON { response in
                if let json = response.result.value {
                    let responseMessage = ResponseMessageWithRecordId.init(json: json)
                    if responseMessage.isSuccess {
                        DB.logout(DB.getUser()!)
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                        self.presentViewController(vc, animated: true, completion: {
                        })
                    }
                    else {
                        let alertView = UIAlertView(title: "", message: "Logout failed. Please check your internet!", delegate: nil, cancelButtonTitle: "Cancel")
                        alertView.show()
                    }
                }
        }
    }


}
