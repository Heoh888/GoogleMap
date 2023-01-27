//
//  AppDelegate.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey(TOKEN)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
}
