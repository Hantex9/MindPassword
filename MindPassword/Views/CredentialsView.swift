//
//  CredentialsView.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class CredentialsView: UIView {

  @IBOutlet weak var emailTextField: CredentialsTextField!
  @IBOutlet weak var passwordTextField: PasswordTextField! {
    didSet {
      passwordTextField.hideBottomBorder()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.layer.cornerRadius = 5.0
    self.layer.borderColor = UIColor.gray.cgColor
    self.layer.borderWidth = 1.0
    
  }

}


