//
//  PasswordTextField.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class PasswordTextField: CredentialsTextField {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let clearButton = self.value(forKey: "clearButton") as! UIButton
    clearButton.setImage(UIImage(named: "eye"), for: .normal)
    self.clearButtonMode = .always
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    self.isSecureTextEntry = !self.isSecureTextEntry
    return false
  }
  
  override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    let actualRect = super.clearButtonRect(forBounds: bounds)
    let rightPadding: CGFloat = 5.0 //Distanza dalla destra
    let newSize = CGSize(width: 25, height: 15)
    let newPosition = CGPoint(x: actualRect.origin.x - (newSize.width - actualRect.size.width) - rightPadding, y: actualRect.origin.y - (newSize.height - actualRect.size.height))
    return CGRect(origin: newPosition, size: newSize)
  }
  
}

