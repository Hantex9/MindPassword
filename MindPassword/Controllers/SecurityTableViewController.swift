//
//  SecurityTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 20/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class SecurityTableViewController: UITableViewController {
  
  @IBOutlet weak var touchIDSwitch: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let touchEnabled = DataManager.shared.isTouchIDEnabled else { return }
    touchIDSwitch.isOn = touchEnabled
  }
  
  @IBAction func switchTouchIDChanged(_ sender: UISwitch) {
    DataManager.shared.isTouchIDEnabled = sender.isOn
    UISelectionFeedbackGenerator().selectionChanged()
  }
}
