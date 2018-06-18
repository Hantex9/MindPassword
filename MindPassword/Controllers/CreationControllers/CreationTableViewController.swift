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
      urlTextField.text = "http://"
      urlTextField.textFieldDidBeginEditing(folderTextField)
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
  
  fileprivate let user = DataManager.shared.user
  fileprivate let dataManager = DataManager.shared
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Tap Gesture to close the keyboard
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
    //Notification for the Keyboard
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    folderTextField.text = dataManager.selectedFolder
    
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
  
  @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    guard let name = nameTextField.text else { return }
    guard !name.isEmpty else {
      self.showAlert(message: NSLocalizedString("Please supply a name", comment: "noNameInsertedError"), title: "MindPassword")
      return
    }
    
    let folder = (folderTextField.text!.isEmpty) ? "(none)" : folderTextField.text!
    let url = (urlTextField.text!.isEmpty) ? nil : urlTextField.text
    let email = (usernameTextField.text!.isEmpty) ? nil : usernameTextField.text
    let password = (passwordTextField.text!.isEmpty) ? nil : passwordTextField.text
    
    DataManager.shared.createSite(user: DataManager.shared.user!, name: name, folder: folder, url: url, email: email, password: password) { (site) in
      print(site)
    }
    
    self.dismiss(animated: true, completion: nil)
    
  }
  
  
  @objc func tapHandler() {
    view.endEditing(true)
  }

}

