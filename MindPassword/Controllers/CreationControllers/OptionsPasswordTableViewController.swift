//
//  OptionsPasswordTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 17/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class OptionsPasswordTableViewController: UITableViewController {
  
  fileprivate let passwordGenerator = PasswordGenerator.shared
  
  @IBOutlet weak var capitalLettersSwitch: UISwitch! {
    didSet {
      capitalLettersSwitch.isOn = passwordGenerator.useCapitalLetters
    }
  }
  @IBOutlet weak var normalLettersSwitch: UISwitch! {
    didSet {
      normalLettersSwitch.isOn = passwordGenerator.useLetters
    }
  }
  @IBOutlet weak var specialCharsSwitch: UISwitch! {
    didSet {
      specialCharsSwitch.isOn = passwordGenerator.useSpecialCharacters
    }
  }
  @IBOutlet weak var numbersSwitch: UISwitch! {
    didSet {
      numbersSwitch.isOn = passwordGenerator.useNumbers
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: Actions
  @IBAction func capitalLettersSwitchSetted(_ sender: UISwitch) {
    passwordGenerator.useCapitalLetters = sender.isOn
  }
  
  @IBAction func normalLettersSwitchSetted(_ sender: UISwitch) {
    passwordGenerator.useLetters = sender.isOn
  }
  
  @IBAction func specialCharsSwitchSetted(_ sender: UISwitch) {
    passwordGenerator.useSpecialCharacters = sender.isOn
  }
  
  @IBAction func numbersSwitchSetted(_ sender: UISwitch) {
    passwordGenerator.useNumbers = sender.isOn
  }
  
}
