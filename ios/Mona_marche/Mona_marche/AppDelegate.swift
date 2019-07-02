//
//  AppDelegate.swift
//  Mona_marche
//
//  Created by raiu on 2019/06/27.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var registrated_address_file_path:String = ""
    var registrated_address = ""
    private var myTabBarController: UITabBarController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()

        let directory_path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        let file_Name = "registration_address.txt"
        self.registrated_address_file_path = directory_path + "/" + file_Name
        print(self.registrated_address_file_path)
        
        do {
            let file_url = NSURL(fileURLWithPath: self.registrated_address_file_path)
            self.registrated_address = try String(contentsOf: file_url as URL, encoding: String.Encoding.utf8)
            print("address : \(self.registrated_address)")
        } catch {
            self.registrated_address = ""
            print("File in not found")
        }
        
        
        if self.registrated_address == "" {
            print("This is first launch")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = FirstRegistrationViewController()
            self.window?.makeKeyAndVisible()
            
            return true
        }
    
        window = UIWindow(frame: UIScreen.main.bounds)
        let shopping_tab: UIViewController = ShoppingViewController()
        let exhibiting_tab: UIViewController = ExhibitingViewController()
        
        let myTabs = NSArray(objects: shopping_tab, exhibiting_tab)
        myTabBarController = UITabBarController()
        myTabBarController?.setViewControllers(myTabs as? [UIViewController], animated: false)
        self.window!.rootViewController = myTabBarController
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    func finish_register() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let shopping_tab: UIViewController = ShoppingViewController()
        let exhibiting_tab: UIViewController = ExhibitingViewController()
        
        let myTabs = NSArray(objects: shopping_tab, exhibiting_tab)
        myTabBarController = UITabBarController()
        myTabBarController?.setViewControllers(myTabs as? [UIViewController], animated: false)
        self.window!.rootViewController = myTabBarController
        self.window!.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

