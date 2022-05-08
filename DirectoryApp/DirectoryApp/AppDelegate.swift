//
//  AppDelegate.swift
//  DirectoryApp
//
//  Created by Geethika on 06/05/22.
//

import UIKit

let brandColor = "#C40202"

/// temp variable to read the data from mock JSON instead of API
let offline = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = UIColor.colorFrom(hex: brandColor)
        return true
    }
}

