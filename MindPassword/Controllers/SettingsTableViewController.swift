//
//  SettingsTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 19/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 && indexPath.section == 1 {
      do {
        try Auth.auth().signOut()
        
        self.dismiss(animated: false, completion: nil)
      } catch {
        print("Error during the logout")
      }
    } 
  }
}
