//
//  IdentificationViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 19/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit
import Firebase

class IdentificationViewController: UIViewController {
  
  @IBOutlet weak var touchIDButton: SubmitButton!
  
  let biometricAuth = BiometricAuth()
  
  var isPresentingTouchID = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let biometricAuth = BiometricAuth()
    let title = (biometricAuth.biometricType() == .faceID) ? NSLocalizedString("Use Face ID to unlock", comment: "") : NSLocalizedString("Use Touch ID to unlock", comment: "")
    touchIDButton.setTitle(title, for: .normal)
  }
  
  
  @IBAction func nextButtonPressed(_ sender: Any) {
    
    self.showTouchID()
  }
  
  @IBAction func logOutButtonPressed(_ sender: Any) {
    DataManager.shared.rememberedPassword = ""
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "LoginView")
    self.present(vc, animated: false, completion: nil)
    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    
    if let _ = Auth.auth().currentUser {
      do {
        try Auth.auth().signOut()
        
      } catch {
        print("Error during the logout")
      }
    }
  }
  
}
