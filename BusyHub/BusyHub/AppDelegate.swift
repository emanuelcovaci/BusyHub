//
//  AppDelegate.swift
//  BusyHub
//
//  Created by Emanuel Covaci on 08/03/2019.
//  Copyright © 2019 Emanuel Covaci. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do{
            _ = try Realm()
        }catch{
            print("Error initialising RealmSwift \(error)")
        }
        return true
    }
    
}
