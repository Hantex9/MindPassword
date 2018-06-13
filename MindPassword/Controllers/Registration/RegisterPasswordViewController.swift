//
//  RegisterPasswordViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController {
  
  @IBOutlet weak var passwordTextField: PasswordTextField! {
    didSet {
      passwordTextField.delegate = passwordTextField
    }
  }
  @IBOutlet weak var confirmPasswordTextField: PasswordTextField! {
    didSet {
      confirmPasswordTextField.delegate = confirmPasswordTextField
    }
  }
  
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
    let storyboard = UIStoryboard(name: "Register", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "FingerView")
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
