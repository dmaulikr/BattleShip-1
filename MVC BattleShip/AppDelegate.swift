//
//  AppDelegate.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/2/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        GameStore.sharedInstance.loadGames()
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: GameSelectionMenu(style: UITableViewStyle.Grouped))
        return true
    }

}

// afnetworking
