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

class LeftViewController: UIViewController {

    
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
        self.imvLogo.clipsToBounds = true
        
         _ = self.menuItemsVar.asObservable().bindTo(self.tbvMenu.rx_itemsWithCellIdentifier("Cell", cellType: LeftMenuCell.self)) {
            row, data, cell in
            cell.menuItem = data
        }.addDisposableTo(self.rx_disosebag)
        
        _ = self.tbvMenu.rx_itemSelected.subscribeNext {
            indexPath in
            let menuItem = self.menuItemsVar.value[indexPath.row]
            

            let vc = self.storyboard?.instantiateViewControllerWithIdentifier(menuItem.vcStoryBoardId!)
            
            self.slideMenuController()?.changeMainViewController(vc!, close: true)
        }.addDisposableTo(self.rx_disosebag)
    }
    
    override func viewDidAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
