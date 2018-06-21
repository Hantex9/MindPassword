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

    let view = UIView(frame: self.window!.bounds)
    let imageView = UIImageView()
    imageView.image = UIImage(named: "locked")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.tag = 1001
    view.backgroundColor = UIColor(red: 222/255, green: 76/255, blue: 40/255, alpha: 1.0)
    
    view.addSubview(imageView)
    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    imageView.contentMode = .scaleAspectFit
    imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    
    UIApplication.shared.keyWindow?.subviews.last?.addSubview(view)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {

  }

  func applicationWillEnterForeground(_ application: UIApplication) {

  }

  func applicationDidBecomeActive(_ application: UIApplication) {

    if let view = UIApplication.shared.keyWindow?.subviews.last?.viewWithTag(1001) {
      view.removeFromSuperview()
      let topViewController = getTopViewController()
      guard !(topViewController is LoginViewController) && !(topViewController is IdentificationPasswordViewController) && !(topViewController is RegistrationNavigationController) else { return }
      
      if let identificationVC = topViewController as? IdentificationViewController {
        
        if !identificationVC.isPresentingTouchID {
          identificationVC.showTouchID()
        }
      } else {
        let storyboard = UIStoryboard(name: "Identification", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "IdentificationView") as! IdentificationViewController
        topViewController.present(vc, animated: false, completion: nil)

        vc.showTouchID()
      }
    }
  }

  func applicationWillTerminate(_ application: UIApplication) {

  }
}

