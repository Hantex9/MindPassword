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
      if scrollView.frame.origin.y <= 0 {
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
//        scrollView.frame.origin.y -= keyboardSize.height
      }
    }
  }
  
  @objc fileprivate func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
//        scrollView.frame.origin.y += keyboardSize.height
    }
  }
  
  // MARK: Actions
  @objc fileprivate func tapHandler(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBAction func setPasswordButtonPressed(_ sender: UIButton) {
    
    view.endEditing(true)
    
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
    
    
    if let error = passwordTextField.errorMessageLabel.text {
      confirmTopConstraint.constant = (error.isEmpty) ? 38.0 : passwordTextField.errorMessageLabel.frame.size.height + 38.0
    }

    
    if errorMessages.confirmPasswordError.isEmpty && errorMessages.passwordError.isEmpty {
      let storyboard = UIStoryboard(name: "Register", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "FingerView")
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}
