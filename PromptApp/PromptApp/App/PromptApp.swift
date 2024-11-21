//
//  PromptAppApp.swift
//  PromptApp
//
//  Created by librius on 2023-11-28.
//

import SwiftUI
import FirebaseCore
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    var viewModel = PromptsData()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        registerLocalNotification()
        return true
    }
    
    func registerLocalNotification() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification authorization granted")
                } else {
                    print("Notification authorization denied")
                }
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Prompt"
            content.body = "There's a new prompt for today!"
//            content.sound = .none

            var dateComponents = DateComponents()
            dateComponents.hour = 24
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "taskNotification", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Failed to add notification request: \(error.localizedDescription)")
                }
            }
        }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "taskNotification" {
            print("background refresh")
            UserService.resetPrompt()
        }
        completionHandler()
    }
    
    
}

@main
struct PromptApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init(){
//        FirebaseApp.configure()
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
