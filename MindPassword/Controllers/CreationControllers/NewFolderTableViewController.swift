//
//  NewFolderTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 17/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class NewFolderTableViewController: UITableViewController {
  
  @IBOutlet weak var folderTextField: CredentialsTextField! {
    didSet {
      folderTextField.borderColor = .clear
      folderTextField.delegate = self
    }
  }
  
  private let doneButton: UIBarButtonItem = {
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
    doneButton.isEnabled = false
    doneButton.tintColor = .white
    return doneButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "New Folder"
    navigationItem.rightBarButtonItem = doneButton
    
    folderTextField.becomeFirstResponder()
  }
  
  private func createFolder(named name: String) {
    DataManager.shared.folder = name
    navigationController?.popToRootViewController(animated: true)
  }
 
  /// - MARK: Actions
  @objc fileprivate func doneButtonPressed(_ sender: UIBarButtonItem) {
    guard let folderName = folderTextField.text else { return }
    createFolder(named: folderName)
  }
  
}

extension NewFolderTableViewController: CredentialsTextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard
      let folderName = textField.text,
      !folderName.isEmpty else {
        return false
    }
    
    createFolder(named: folderName)
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newLength = textField.text!.utf16.count + string.utf16.count - range.length
    doneButton.isEnabled = newLength >= 1

    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    folderTextField.textFieldDidBeginEditing(textField)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
    folderTextField.textFieldDidEndEditing(textField)
  }
  
}
