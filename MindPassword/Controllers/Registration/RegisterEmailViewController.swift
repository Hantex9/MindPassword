//
//  RegisterMainViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class RegisterEmailViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: CredentialsTextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    view.addGestureRecognizer(tapGesture)
    
    setNavigationLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  fileprivate func setNavigationLayout() {
    navigationController?.navigationBar.tintColor = UIColor(red: 180/255, green: 50/255, blue: 63/255, alpha: 1.0)
  }
  
  // MARK: Actions
  @objc fileprivate func tapHandler(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  @IBAction func createButtonPressed(_ sender: UIButton) {
    
    if let errorMessage = DataManager.shared.isValidEmail(email: emailTextField.text) {
      emailTextField.showErrorMessage(message: errorMessage)
    } else {
      emailTextField.dismissErrorMessage()
      let storyboard = UIStoryboard(name: "Register", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "PasswordView")
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @IBAction func signInButtonPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
