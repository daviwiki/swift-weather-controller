//
//  AppDelegate.swift
//  Weather
//
//  Created by David Martinez on 11/08/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = try! WeatherConfigurator.default.getWeatherController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

