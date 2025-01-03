//
//  AppDelegate.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 02/04/2024.
//

import UIKit
import GoogleMaps
import FirebaseCore
import MOLH

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
        setUpNavigationBar()
        GMSServices.provideAPIKey("AIzaSyB9Gu55XnI_UEP_hnW5GKVtWiAt-nxxxeU")
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setUpNavigationBar(){
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor.black
    }

    func reset() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let newRootViewController = SettingsVC(nibName: "SettingsVC", bundle: nil)
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    window.rootViewController = newRootViewController
                }, completion: nil)
                window.makeKeyAndVisible()
            }
        }
    }
}

