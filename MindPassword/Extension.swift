//
//  Extension.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 15/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
  
  func showAlert(message: String, title: String = NSLocalizedString("Error", comment: "errorAlertMessage")) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "closeAlert"), style: .cancel, handler: nil))
    
    self.present(alert, animated: true)
  }
  
  func showAlert(message: String, title: String = NSLocalizedString("Error", comment: "errorAlertMessage"), handler: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "closeAlert"), style: .cancel) { _ in 
      handler()
    })
    
    self.present(alert, animated: true)
  }
  
  func copyInClipboard(text: String) {
    let pasteBoard = UIPasteboard.general
    pasteBoard.string = text
  }
  
  func showPopup(message: String, distanceFromBottom: CGFloat = 80.0) {
    
    let kVCTagPopupView = 100
    self.view.subviews.forEach {
      if $0.tag == kVCTagPopupView {
        $0.removeFromSuperview()
        return
      }
    }
    
    let view = UIView()
    view.backgroundColor = .black
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 5.0
    view.alpha = 0.0
    view.tag = kVCTagPopupView
    
    let label = UILabel()
    label.text = message
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16.0)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.frame.size = CGSize(width: 300.0, height: 300.0)
    label.sizeToFit()
    
    view.addSubview(label)
    
    self.view.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height - (label.frame.size.height - 20.0) - distanceFromBottom), //Da modificare
      view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      view.widthAnchor.constraint(equalToConstant: label.frame.size.width + 15.0),
      view.heightAnchor.constraint(equalToConstant: label.frame.size.height + 15.0),
      
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10.0),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    
    UIView.animate(withDuration: 0.5, animations: {
      view.alpha = 0.8
    }) { _ in
      UIView.animate(withDuration: 0.5, delay: 3.0, options: [.curveEaseInOut], animations: {
        view.alpha = 0.0
      }, completion: { (_) in
        view.removeFromSuperview()
      })
    }
    
  }
  
  func showTouchID() {
    if let identificationVC = self as? IdentificationViewController {
      identificationVC.isPresentingTouchID = true
    }
    
    if let touchIDEnabled = DataManager.shared.isTouchIDEnabled, touchIDEnabled {
      let biometricAuth = BiometricAuth()
      biometricAuth.authenticateUser { (error) in
        
        guard error == nil else {

          if error == NSLocalizedString("Face ID/Touch ID is not available.", comment: "") || error == NSLocalizedString("Touch ID not available", comment: "")/* || error == NSLocalizedString("There was a problem verifying your identity.", comment: "") */{
            
            print("shows textfield with password")
            let storyboard = UIStoryboard(name: "Identification", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PasswordIdentification")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
              self.present(vc, animated: false, completion: nil)
            })
            
          }
          return
        }
        
        if let identificationVC = self as? IdentificationViewController {
          identificationVC.isPresentingTouchID = false
        }
        print("should dismiss")
        self.dismiss(animated: false, completion: nil)
      }
    } else {
      let storyboard = UIStoryboard(name: "Identification", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "PasswordIdentification")
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
        self.present(vc, animated: false, completion: nil)
      })
    }
  }
}

extension String {
  public mutating func append(_ other: String) {
    if self.isEmpty {
      self += other
    } else {
      self += "\n" + other
    }
  }
}

func getTopViewController() -> UIViewController {
  
  var viewController = UIViewController()
  
  if let vc =  UIApplication.shared.delegate?.window??.rootViewController {
    
    viewController = vc
    var presented = vc
    
    while let top = presented.presentedViewController {
      presented = top
      viewController = top
    }
  }
  
  return viewController
}
