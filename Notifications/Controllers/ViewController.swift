//
//  ViewController.swift
//  Notifications
//
//  Created by Sprinthub on 01/04/2019.
//  Copyright © 2019 Sprinthub Mobile. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        center.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal(){
        center.getNotificationSettings(completionHandler: {(settings) in
            switch settings.authorizationStatus{
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
                    if granted {
                        print("Yay!")
                    }else{
                        print("D'Oh")
                    }
                })
                break
            case .denied:
                let ac = UIAlertController(title: "Error", message: "Notification permission denied, please grant notification access in system settings", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
                break
            case .authorized:
                //app can send notifications, biko leave am like that
                print("app can send notifications, biko leave am like that")
                break
            case .provisional:
                //i never sabi wetin this one be first. make we just leave am like that
                break
            }
        })
        
    }
    
    @objc func scheduleLocal(){
        center.removeAllPendingNotificationRequests()
        
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    func registerCategories() {
//        let center = UNUserNotificationCenter.current()
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                
            default:
                break
            }
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }

}

