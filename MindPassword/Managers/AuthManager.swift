//
//  RegistrationManager.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 14/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthManager {
  
  public static let shared = AuthManager()
  
  private let dataManager = DataManager.shared
  
  private init() {
    
  }
  
  func registerUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      guard error == nil else { return completion(error) }
      completion(nil)
    }
  }
  
  
  func loginUser(email: String, password: String, completion: @escaping (String?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      
      guard error == nil else {
        if error!._code == AuthErrorCode.wrongPassword.rawValue {
          completion(NSLocalizedString("Wrong password, retry!", comment: "wrongPasswordError"))
        } else if error!._code == AuthErrorCode.userNotFound.rawValue {
          completion(NSLocalizedString("Account with this email doesn't exists", comment: "accountNotFoundError"))
        } else {
          completion(NSLocalizedString("Something went wrong, retry later!", comment: "noInternetError"))
        }
        return
      }
      if let result = result {
        self.dataManager.user = User(uuid: result.user.uid, email: result.user.email!, sites: [])
      }
      completion(nil)
    }
  }
  
  
  func isValidEmail(email: String?) -> String? {
    guard let email = email, !email.isEmpty else { return NSLocalizedString("Insert a valid email", comment: "emailErrorText") }
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    return (emailTest.evaluate(with: email)) ? nil : NSLocalizedString("Insert a valid email.", comment: "invalidEmailText")
    
  }
  
  func validate(password: String, email: String, completion: @escaping (String?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
      guard error == nil else {
        completion(NSLocalizedString("Invalid password, retry!", comment: ""))
        return
      }
      completion(nil)
    }
  }
  
  
  func validate(email: String, completion: @escaping (Bool, String?) -> Void) {
    
    Auth.auth().fetchProviders(forEmail: email) { (stringArray, error) in
      guard error == nil else {
        completion(false, NSLocalizedString("Something went wrong, retry later.", comment: "errorFetchEmailText"))
        return
      }
      
      guard stringArray == nil else {
        completion(false, NSLocalizedString("This email is already in use.", comment: "emailInUseError"))
        return
      }
      
      completion(true, nil)
    }
  }
  
  
  func isValidPassword(password: String?, confirmPassword: String?, isRegistrationCheck: Bool = true) -> (passwordError: String, confirmPasswordError: String) {
    var errors: (passwordError: String, confirmPasswordError: String) = ("", "")
    
    if let password = password, password.isEmpty {
      errors.passwordError = NSLocalizedString("- Insert a valid password", comment: "insertPasswordError")
    }
    if let password = password, isRegistrationCheck && password.count < 8 {
      errors.passwordError.append(NSLocalizedString("- The password must have at least 8 characters", comment: "insecurePasswordError"))
    }
    if let confirmPassword = confirmPassword, isRegistrationCheck && confirmPassword.isEmpty {
      errors.confirmPasswordError = NSLocalizedString("- Reinsert the password here", comment: "insertPasswordError")
    }
    if password != confirmPassword && isRegistrationCheck && !password!.isEmpty && !confirmPassword!.isEmpty {
      errors.confirmPasswordError.append(NSLocalizedString("- The password doesn't match", comment: "passwordDoesntMatchError"))
    }
    return errors
  }
  
}
