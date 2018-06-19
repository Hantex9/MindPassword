//
//  LoginViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

  @IBOutlet weak var switchPassword: UISwitch! {
    didSet {
      switchPassword.isOn = !dataManager.rememberedPassword!.isEmpty
    }
  }
  
  @IBOutlet weak var switchEmail: UISwitch! {
    didSet {
      switchEmail.isOn = !dataManager.rememberedEmail!.isEmpty
    }
  }
  
  @IBOutlet weak var loginButton: SubmitButton! {
    didSet {
      loginButton.layer.cornerRadius = 5.0
      loginButton.layer.masksToBounds = true
    }
  }
  
  @IBOutlet weak var emailTextField: CredentialsTextField!
  @IBOutlet weak var passwordTextField: PasswordTextField!
  
  fileprivate let authManager = AuthManager.shared
  fileprivate let dataManager = DataManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupGestures()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    emailTextField.text = dataManager.rememberedEmail
    if !dataManager.rememberedEmail!.isEmpty {
      emailTextField.textFieldDidBeginEditing(emailTextField)
    } else {
      emailTextField.textFieldDidEndEditing(emailTextField)
    }
    
    passwordTextField.text = dataManager.rememberedPassword
    if !dataManager.rememberedPassword!.isEmpty {
      passwordTextField.textFieldDidBeginEditing(passwordTextField)
    } else {
      passwordTextField.textFieldDidEndEditing(passwordTextField)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if let alreadySignedIn = Auth.auth().currentUser {
      let storyboard = UIStoryboard(name: "Home", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "HomeView")
      let user = User(uuid: alreadySignedIn.uid, email: alreadySignedIn.email, sites: nil)
      DataManager.shared.user = user
      self.present(vc, animated: false, completion: nil)
    }
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
      authManager.loginUser(email: email!, password: password!) { (errorMessage) in
      
        sender.isFetchingData = false
        
        guard errorMessage == nil else {
          self.showAlert(message: errorMessage!)
          return
        }
        
        self.dataManager.rememberedEmail = (self.switchEmail.isOn) ? email : ""
        self.dataManager.rememberedPassword = (self.switchPassword.isOn) ? password : ""

        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeView")
        self.present(vc, animated: false, completion: nil)
        
      }
    }
  }
  
}
