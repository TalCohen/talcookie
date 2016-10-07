//
//  NotificationManager.swift
//  TalCookie
//
//  Created by Tal Cohen on 10/6/16.
//  Copyright © 2016 Computer Science House. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    let clickURLString = "http://gravity.csh.rit.edu:3333/click"
    
    func registerForPushNotifications(application: UIApplication, viewController: UIViewController?) {
        // Get the notification center
        let center = UNUserNotificationCenter.current()
        
        // Request authorization
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // If notifications are granted, register for remote notifications
            if granted {
                print("Notification authorization granted")
                application.registerForRemoteNotifications()
            } else {
                // Present an alert warning the user that they didn't grant access.
                if let viewController = viewController {
                    self.presentNotificationWarning(application: application, viewController: viewController)
                }
            }
        }
    }
    
    func presentNotificationWarning(application: UIApplication, viewController: UIViewController) {
        // Create and present an alert
        let alert = UIAlertController(title: "Notification Permission Denied", message: "This app relies on receiving push notifications. Please enable them from the Settings app if you want to continue.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (okay) in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(settingsURL, completionHandler: { (completed) in
                    if (completed) {
                        // Try again to register. If they didn't grant permission we'll stop unless they click register again.
                        self.registerForPushNotifications(application: application, viewController: nil)
                    }
                })
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        alert.preferredAction = okayAction
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func registerNotificationCategories() {
        // Define click action
        let clickAction = UNNotificationAction(identifier: "CLICK_IDENTIFIER", title: "Click!", options: [])
        
        // Define the category
        let category = UNNotificationCategory(identifier: "GOLDEN_COOKIE", actions: [clickAction], intentIdentifiers: [], options: [])
        
        // Set the notification categories
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
    }
    
    func sendClick() {
        // Get the data needed
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let defaults = UserDefaults.standard
        guard let deviceToken = defaults.string(forKey: appDelegate.utilities.deviceTokenKey) else {
            print("No device token registered.")
            return
        }
        
        // Make the request
        var request = URLRequest(url: URL(string: clickURLString)!)
        request.httpMethod = "POST"
        let postString = "device_token=\(deviceToken)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with request: \(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let dataString = String(data: data!, encoding: .utf8)
            print(dataString)
        }
        print("sending request...")
        task.resume()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        print(response)
        print(actionIdentifier)
        
        if (actionIdentifier == "CLICK_IDENTIFIER") {
            print("sending click...")
            sendClick()
        }
        
        completionHandler()
        
    }
}
