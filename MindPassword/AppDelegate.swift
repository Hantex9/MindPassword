//
//  AppDelegate.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    let view = UIView(frame: self.window!.bounds)
    view.tag = 1001
    view.backgroundColor = .red
    
    UIApplication.shared.keyWindow?.subviews.last?.addSubview(view)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if let view = UIApplication.shared.keyWindow?.subviews.last?.viewWithTag(1001) {
      view.removeFromSuperview()
      let storyboard = UIStoryboard(name: "Identification", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "IdentificationView")
      getTopViewController().present(vc, animated: false, completion: nil)
    }
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

