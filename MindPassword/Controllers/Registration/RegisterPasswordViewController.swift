//
//  RegisterPasswordViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController {
  
  @IBOutlet weak var passwordTextField: PasswordTextField!
  @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
  @IBOutlet weak var confirmTopConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    view.addGestureRecognizer(tapGesture)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: Actions
  @objc fileprivate func tapHandler(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBAction func setPasswordButtonPressed(_ sender: UIButton) {
    
    let errorMessages = DataManager.shared.isValidPassword(password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text)
    
    if !errorMessages.passwordError.isEmpty {
      passwordTextField.showErrorMessage(message: errorMessages.passwordError)
      if errorMessages.confirmPasswordError.isEmpty {
        confirmPasswordTextField.dismissErrorMessage()
      }
    }
    
    if !errorMessages.confirmPasswordError.isEmpty {
      confirmPasswordTextField.showErrorMessage(message: errorMessages.confirmPasswordError)
      if errorMessages.passwordError.isEmpty {
        passwordTextField.dismissErrorMessage()
      }
    }
    
    
    confirmTopConstraint.constant = (passwordTextField.errorMessageLabel.text!.isEmpty) ? 15.0 : passwordTextField.errorMessageLabel.frame.size.height + 15.0
    confirmTopConstraint.constant = (passwordTextField.errorMessageLabel.text!.isEmpty) ? 15.0 : passwordTextField.errorMessageLabel.frame.size.height + 15.0

    
    if errorMessages.confirmPasswordError.isEmpty && errorMessages.passwordError.isEmpty {
      let storyboard = UIStoryboard(name: "Register", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "FingerView")
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}
