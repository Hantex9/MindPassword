//
//  BiometricManager.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 20/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

class BiometricAuth {
  
  let context = LAContext()
  
  func biometricType() -> BiometricType {
    let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    
    switch context.biometryType {
    case .none:
      return .none
    case .touchID:
      return .touchID
    case .faceID:
      return .faceID
    }
  }
  
  func authenticateUser(completion: @escaping (String?) -> Void) {
    
    guard canEvaluatePolicy() else {
      completion("Touch ID not available")
      return
    }
    
    let reason = NSLocalizedString("Scan your fingerprint to continue.", comment: "scan fingerprint")
    
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, evaluateError) in
      if success {
        DispatchQueue.main.async {
          completion(nil)
        }
      } else {
        let message: String
        
        switch evaluateError {
        case LAError.authenticationFailed?:
          message = NSLocalizedString("There was a problem verifying your identity.", comment: "")
        case LAError.userCancel?:
          message = NSLocalizedString("You pressed cancel.", comment: "")
        case LAError.userFallback?:
          message = NSLocalizedString("You pressed password.", comment: "")
        case LAError.biometryNotAvailable?:
          message = NSLocalizedString("Face ID/Touch ID is not available.", comment: "")
        case LAError.biometryNotEnrolled?:
          message = NSLocalizedString("Face ID/Touch ID is not set up.", comment: "")
        case LAError.biometryLockout?:
          message = NSLocalizedString("Face ID/Touch ID is locked.", comment: "")
        default:
          message = NSLocalizedString("Face ID/Touch ID may not be configured", comment: "")
        }
        
        completion(message)
      }
    }
  }
  
  func canEvaluatePolicy() -> Bool {
    return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
  }
  
}
