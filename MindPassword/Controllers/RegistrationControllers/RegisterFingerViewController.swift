//
//  RegisterFingerViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit
import LocalAuthentication

class RegisterFingerViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.text = NSLocalizedString("Unlock MinPassword with your ", comment: "") + biometricTextInput
    }
  }
  @IBOutlet weak var descriptionLabel: UILabel! {
    didSet {
      descriptionLabel.text = NSLocalizedString("Use your \(biometricTextInput) to open your vault and keep your account safe.", comment: "")
    }
  }
  @IBOutlet weak var turnOnButton: SubmitButton! {
    didSet {
      let text = NSLocalizedString("TURN ON ", comment: "") + biometricTypeText.uppercased()
      turnOnButton.setTitle(text, for: .normal)
    }
  }
  
  
  
  fileprivate let biometricAuth = BiometricAuth()
  fileprivate var biometricTextInput: String {
    get {
      return (biometricAuth.biometricType() == .faceID) ? NSLocalizedString("face", comment: "") : NSLocalizedString("fingerprint", comment: "")
    }
  }
  fileprivate var biometricTypeText: String {
    get {
      return (biometricAuth.biometricType() == .faceID) ? "Face ID" : "Touch ID"
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.setHidesBackButton(true, animated: true)
    let skipButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipButtonPressed))
    navigationItem.setRightBarButton(skipButton, animated: true)
  }
  
  @objc fileprivate func skipButtonPressed() {
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func touchIDButtonPressed(_ sender: SubmitButton) {
    
    let biometricAuth = BiometricAuth()
    
    biometricAuth.authenticateUser { (errorMessage) in
      var message = ""
      var title = ""
      if let _ = errorMessage {
        message = NSLocalizedString("Setting up \(self.biometricTypeText) failed.\nYou can enable it later on the Settings tab.", comment: "noTouchDetected")
        title = NSLocalizedString("Error", comment: "")
      } else {
        DataManager.shared.isTouchIDEnabled = true
        message = NSLocalizedString("\(self.biometricTypeText) Authentication succeed.", comment: "successTouchIDMessage")
        title = NSLocalizedString("Success", comment: "success string in touch id register")
      }
      
      self.showAlert(message: message, title: NSLocalizedString(title, comment: "successTouchIDTitle")) {
        if let view = UIApplication.shared.keyWindow?.subviews.last?.viewWithTag(1001) {
          view.removeFromSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          self.navigationController?.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
}
