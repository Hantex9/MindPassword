//
//  CreationTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 16/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class CreationTableViewController: UITableViewController {
  
  @IBOutlet weak var nameTextField: CredentialsTextField! {
    didSet {
      nameTextField.borderColor = UIColor.clear
    }
  }
  @IBOutlet weak var folderTextField: CredentialsTextField! {
    didSet {
      folderTextField.borderColor = UIColor.clear
      folderTextField.textFieldDidBeginEditing(folderTextField)
    }
  }
  @IBOutlet weak var urlTextField: CredentialsTextField! {
    didSet {
      urlTextField.borderColor = UIColor.clear
    }
  }
  @IBOutlet weak var usernameTextField: CredentialsTextField! {
    didSet {
      usernameTextField.borderColor = UIColor.clear
    }
  }
  @IBOutlet weak var passwordTextField: PasswordTextField! {
    didSet {
      passwordTextField.borderColor = UIColor.clear
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Notification for the Keyboard
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let folderName = DataManager.shared.folder {
      folderTextField.text = folderName
    } else {
      folderTextField.text = ""
    }
    
  }
  
  /// MARK: Observers
  @objc fileprivate func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
      tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
    }
  }
  
  @objc fileprivate func keyboardWillHide(notification: NSNotification) {
    tableView.contentInset = UIEdgeInsets.zero
    tableView.scrollIndicatorInsets = UIEdgeInsets.zero
  }
  
  
  /// MARK: Actions
  @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }

}


//func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//  let newLength = count(textField.text.utf16) + count(string.utf16) - range.length
//  mylabel.text =  String(newLength)
//
//  return newLength <= 25 // To just allow up to 25 characters
//  return true
//}

