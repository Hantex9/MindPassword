//
//  LoginViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var loginButton: SubmitButton! {
    didSet {
      loginButton.layer.cornerRadius = 5.0
      loginButton.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var emailTextField: CredentialsTextField!
  @IBOutlet weak var passwordTextField: PasswordTextField!
  
  fileprivate let authManager = AuthManager.shared
  
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
  
  @IBAction func loginButtonPressed(_ sender: SubmitButton) {
    var errors = ""
    let
      email = emailTextField.text,
      password = passwordTextField.text
    
    sender.isFetchingData = true
    
    let emailErrors = authManager.isValidEmail(email: email)
    if let error = emailErrors {
      errors.append(error)
    }
    
    let passwordErrors = authManager.isValidPassword(password: password, confirmPassword: nil, isRegistrationCheck: false)
    if !passwordErrors.passwordError.isEmpty {
      errors.append(passwordErrors.passwordError)
    }
    
    if !errors.isEmpty {
      sender.isFetchingData = false
      showAlert(message: errors)
    } else {
//      authManager.loginUser(email: email!, password: password!) { (errorMessage) in
      
        sender.isFetchingData = false
        
        /*guard errorMessage == nil else {
          self.showAlert(message: errorMessage!)
          return
        }*/
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeView")
        self.present(vc, animated: false, completion: nil)
        
//      }
    }
  }
  
}
