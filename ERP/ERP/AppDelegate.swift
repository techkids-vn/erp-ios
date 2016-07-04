//
//  AppDelegate.swift
//  ERP
//
//  Created by admin on 6/12/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import ReachabilitySwift
import TTGSnackbar

let TEST = true
var reachability : Reachability?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.checkInternet()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let user = DB.getUser() {
            if user.didLogin == 1 {
                
                let leftVC = mainStoryboard.instantiateViewControllerWithIdentifier("LeftViewController")
                
                let navVC = mainStoryboard.instantiateViewControllerWithIdentifier("NavigationController") as! NavigationController
                
                let slideVC = SlideMenuController(mainViewController: navVC, leftMenuViewController: leftVC)
                
                self.window!.rootViewController = slideVC
                self.window?.makeKeyAndVisible()
                self.customApperance()
                return true

            }
        }
        
        let loginVC = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
        self.window!.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
        self.customApperance()
        return true

    }
    
    func fetchClasses() {
        NetworkContext.fetchAllClasses( {
            objs in
            Class.all = objs.map { obj in return obj as! Class }
        })
    }
    
    func fetchRoles() {
        NetworkContext.fetchAllRoles ( {
            objs in
            Role.all = objs.map { obj in return obj as! Role }
        })
    }
    
    func customApperance() {
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().barTintColor = TOP_BACKGROUND_COLOR
        UISearchBar.appearance().setImage(UIImage(named: "img-searchbar"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    func checkInternet() {
        do {
            reachability = try! Reachability.reachabilityForInternetConnection()
        }
        reachability!.whenUnreachable = {
            reachability in
            dispatch_async(dispatch_get_main_queue()) {
                let snackbar = TTGSnackbar.init(message: "Couldn't conect to the server. Check your network connection", duration: .Middle, actionText: "")
                { (snackbar) -> Void in
                }
                snackbar.show()

            }
        }
        
        reachability!.whenReachable = {
            reachability in
            dispatch_async(dispatch_get_main_queue()){
                let teachingRequests = DB.getAllTeachingRecordRequests()
                for teachingRequest in teachingRequests {
                    if teachingRequest.record != nil {
                        NetworkContext.sendTeachingRecordRequest(teachingRequest, requestDone: {
                            code, message in
                            if code == NetworkContext.RESULT_CODE_SUCCESS {
                                //let instructorName = DB.getInstructorByCode((teachingRequest.record?.code)!)
                                let snackbar = TTGSnackbar.init(message: "Record has been requested to server", duration: .Middle, actionText: "")
                                { (snackbar) -> Void in
                                }      
                                snackbar.show()
                                DB.deleteTeachingRecordRequest(teachingRequest)
                            }
                            else {
                                let alert = UIAlertView(title: "", message: "Record Fail", delegate: nil,
                                    cancelButtonTitle: "Ok")
                                alert.show()
                            }
                        })

                    }
                }
            }
        }

        
        try! reachability?.startNotifier()

    }
    
    func addTapped() {}

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

