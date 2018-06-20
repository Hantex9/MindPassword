//
//  IdentificationPasswordViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 20/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit
import Firebase

class IdentificationPasswordViewController: UIViewController {
  
  fileprivate let authManager = AuthManager.shared
  
  @IBOutlet weak var passwordTextField: PasswordTextField! {
    didSet {
      passwordTextField.borderColor = .gray
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
  
  @IBAction func loginButtonPressed(_ sender: SubmitButton) {
    authManager.validate(password: passwordTextField.text!, email: Auth.auth().currentUser!.email!) { (errorMessage) in
      guard errorMessage == nil else {
        self.showAlert(message: errorMessage!)
        return
      }
      
      self.dismiss(animated: false) {
        getTopViewController().dismiss(animated: false, completion: nil)
      }
    }
  }
  
  
  
}
