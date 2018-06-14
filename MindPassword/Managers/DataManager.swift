//
//  DataManager.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 14/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import Foundation

class DataManager {
  
  public static let shared = DataManager()
  
  private init() {
    
  }
  
  func isValidEmail(email: String?) -> String? {
    guard let email = email, !email.isEmpty else { return NSLocalizedString("Insert the email.", comment: "emailErrorText") }
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return (emailTest.evaluate(with: email)) ? nil : NSLocalizedString("Invalid email.", comment: "invalidEmailText")
  }
  
  func isValidPassword(password: String?, confirmPassword: String?) -> (passwordError: String, confirmPasswordError: String) {
    var errors: (passwordError: String, confirmPasswordError: String) = ("", "")
    if let password = password, password.isEmpty {
      errors.passwordError = NSLocalizedString("- Insert the password here", comment: "insertPasswordError") + "\n"
    }
    if let password = password, password.count < 8 {
      errors.passwordError.append(NSLocalizedString("- The password must have at least 8 characters", comment: "insecurePasswordError"))
    }
    if let confirmPassword = confirmPassword, confirmPassword.isEmpty {
      errors.confirmPasswordError = NSLocalizedString("- Reinsert the password here", comment: "insertPasswordError")
    }
    if password != confirmPassword && !password!.isEmpty && !confirmPassword!.isEmpty {
      errors.confirmPasswordError.append(NSLocalizedString("- The password doesn't match", comment: "passwordDoesntMatchError"))
    }
    return errors
  }
}
