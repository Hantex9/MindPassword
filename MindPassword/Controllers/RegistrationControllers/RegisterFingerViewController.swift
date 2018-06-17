//
//  RegisterFingerViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class RegisterFingerViewController: UIViewController {

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

}
