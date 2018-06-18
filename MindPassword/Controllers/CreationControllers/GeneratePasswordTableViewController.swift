//
//  GeneratePasswordTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 16/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class GeneratePasswordTableViewController: UITableViewController {
  
  @IBOutlet weak var generatePasswordView: GeneratedPasswordView!
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var lengthNumberLabel: UILabel!
  
  fileprivate let passwordGenerator = PasswordGenerator.shared
  fileprivate var lengthPassword: Int = 8 {
    didSet {
      lengthNumberLabel.text = "\(lengthPassword)"
      passwordGenerator.numberOfCharacters = lengthPassword
    }
  }
  
  fileprivate var generatedPassword: String = "" {
    didSet {
      generatePasswordView.generatedPasswordLabel.text = generatedPassword
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem?.tintColor = .white
    slider.addTarget(self, action: #selector(sliderDidEndSliding), for: ([.touchUpInside, .touchUpOutside]))
    
    lengthPassword = Int(slider.value)
    generatedPassword = passwordGenerator.generate()
    
  }
  
  
  // MARK: Actions
  @IBAction func refreshButtonPressed(_ sender: UIButton) {
    print("refresh password in text")
    generatedPassword = passwordGenerator.generate()
  }
  
  @IBAction func lengthSliderValueChanged(_ sender: UISlider) {
    lengthPassword = Int(sender.value)
  }
  
  @objc func sliderDidEndSliding() {
    print("create the new password with new length")
    generatedPassword = passwordGenerator.generate()
  }
  
  /// MARK: TableView Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = indexPath.row
    if row == 2 {
      tableView.cellForRow(at: indexPath)?.isSelected = false
      self.copyInClipboard(text: generatedPassword)
      self.showPopup(message: NSLocalizedString("Copied value to the clipboard\n\n", comment: "messageCopiedPopup") + generatedPassword)
    }
  }
  
}


