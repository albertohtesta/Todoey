//
//  AppDelegate.swift
//  Todoey
//
//  Created by Alberto Hernandez Testa on 8/25/19.
//  Copyright © 2019 Alberto Hernandez Testa. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(Realm.Configuration.defaultConfiguration.fileURL!) // **** para saber donde esta nuestra BD
        
        do {
            _ = try Realm()
        }
        catch {
            print("Error initialising new Realm, \(error)")
        }

        return true
    }

    
 
}

