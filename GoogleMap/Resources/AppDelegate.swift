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
        let center = UNUserNotificationCenter.current()
        registerPermission(center: center)
        return true
    }
    
    private func registerPermission(center: UNUserNotificationCenter) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("permission no granted")
                return
            }
            let content = self.createContent()
            let trigger = self.createTrigger()
            self.sendNotificationRequest(content: content, trigger: trigger)
        }
    }
    
    private func createContent() -> UNNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = "Wake Up, Neo"
        content.subtitle = "The Matrix has you"
        content.body = "Follow the white rabbit"
        content.userInfo = ["key": "Hello world!"]
        return content
    }
    
    private func createTrigger() -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: 1800, repeats: false)
    }
    
    private func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let requst = UNNotificationRequest(identifier: "timeNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(requst) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
