//
//  LoginViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var loginButton: UIButton! {
    didSet {
      loginButton.layer.cornerRadius = 5.0
      loginButton.layer.masksToBounds = true
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupGestures()
    
  }
  
  fileprivate func setupGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    view.addGestureRecognizer(tapGesture)
  }
  
  // MARK: Actions
  @objc fileprivate func tapHandler(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
}
