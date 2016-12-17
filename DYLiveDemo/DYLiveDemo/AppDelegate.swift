//
//  AppDelegate.swift
//  DYLiveDemo
//
//  Created by xiaokui wu on 12/15/16.
//  Copyright © 2016 wxk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        return true
    }

}

