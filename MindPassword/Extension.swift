//
//  Extension.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 15/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    
    //    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "closeAlert"), style: .cancel, handler: nil))
    
    self.present(alert, animated: true)
  }
  
  func showPopup(message: String) {
    
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
      view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height - (label.frame.size.height - 20.0) - 80.0), //Da modificare
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
