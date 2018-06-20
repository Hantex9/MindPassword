//
//  RegisterPasswordViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var passwordTextField: PasswordTextField!
  @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
  @IBOutlet weak var confirmTopConstraint: NSLayoutConstraint!
  
  fileprivate let authManager = AuthManager.shared
  
  var userEmail: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    view.addGestureRecognizer(tapGesture)
    
    //Notification for the Keyboard
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  @objc fileprivate func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
      scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
    }
  }
  
  @objc fileprivate func keyboardWillHide(notification: NSNotification) {
    scrollView.contentInset = UIEdgeInsets.zero
    scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
  }
  
  // MARK: Actions
  @objc fileprivate func tapHandler(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBAction func setPasswordButtonPressed(_ sender: SubmitButton) {
    
    view.endEditing(true)
    sender.isFetchingData = true
  
    let password = passwordTextField.text
    
    let errorMessages = authManager.isValidPassword(password: password, confirmPassword: confirmPasswordTextField.text)
    
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
    
    if let error = passwordTextField.errorMessageLabel.text {
      confirmTopConstraint.constant = (error.isEmpty) ? 38.0 : passwordTextField.errorMessageLabel.frame.size.height + 38.0
    }

    if errorMessages.confirmPasswordError.isEmpty && errorMessages.passwordError.isEmpty {
      
      authManager.registerUser(email: userEmail, password: password!) { (error) in
        
        sender.isFetchingData = false
        
        guard error == nil else {
          return self.showAlert(message: NSLocalizedString("Something went wrong, retry later.", comment: "passwordDBErrorMessage"))
        }
        
        DataManager.shared.isNewUser = true
        
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FingerView")
        self.navigationController?.pushViewController(vc, animated: true)
      }
    } else {
      sender.isFetchingData = false
    }
  }
  
}
