//
//  OptionsTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 19/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var options: [(image: UIImage, text: String)] = []
  
  var site: Site!
  var rootViewController: UIViewController!
  var isFirstView: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()

    DispatchQueue.main.async {
      self.tableView.dataSource = self
      self.tableView.delegate = self
    }
    
    view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
    loadOptions()
    
    //Tap gesture
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.tableView.backgroundColor = .white
  }
  
  @objc func tapHandler(_ sender: UITapGestureRecognizer) {
    let position = sender.location(in: self.tableView)
    guard tableView.indexPathForRow(at: position) == nil else { return }
    
    dismissAnimation {
      self.dismiss(animated: false, completion: nil)
    }
    
  }
  
  fileprivate func loadOptions() {
    if let _ = site.email  {
      options.append((image: #imageLiteral(resourceName: "user"), text: NSLocalizedString("Copy Username", comment: "copyUsernameOption")))
    }
    if let _ = site.password {
      options.append((image: #imageLiteral(resourceName: "copy"), text: NSLocalizedString("Copy Password", comment: "copyPasswordOption")))
    }
    options.append((image: #imageLiteral(resourceName: "edit"), text: NSLocalizedString("Edit", comment: "editOption")))
    if let _ = site.password {
      options.append((image: #imageLiteral(resourceName: "eye"), text: NSLocalizedString("Show Password", comment: "showPasswordOption")))
    }
    options.append((image: #imageLiteral(resourceName: "delete"), text: NSLocalizedString("Delete", comment: "deleteOption")))
  }
  
  fileprivate func dismissAnimation(completion: @escaping () -> Void) {
    UIView.animate(withDuration: 0.1, animations: {
      self.tableView.frame.origin.y = UIScreen.main.bounds.height
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }) { _ in
      completion()
    }
  }
  
  
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return options.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! OptionsTableViewCell
    
    if indexPath.row == 0 {
      cell.trailingConstraint.constant = 0
      cell.optionLabel.text = site.name
      cell.optionLabel.textAlignment = .center
      cell.layoutSubviews()
      cell.isUserInteractionEnabled = false
      return cell
    }
    
    cell.optionLabel.text = options[indexPath.row - 1].text
    cell.iconImageView.image = options[indexPath.row - 1].image
    
    if indexPath.row == options.count && isFirstView {
      isFirstView = false
      self.tableView.frame.origin.y = UIScreen.main.bounds.height + 20.0
      UIView.animate(withDuration: 0.1) {
        self.tableView.frame.origin.y = self.tableView.frame.size.height - self.tableView.contentSize.height - 10.0
        self.tableView.frame.size.height = self.tableView.contentSize.height + 10.0
      }

    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row - 1
    
    switch options[index].image {
      case #imageLiteral(resourceName: "user"):
        self.copyInClipboard(text: site.email!)
        dismissAnimation {
          self.dismiss(animated: false, completion: nil)
        }
        rootViewController.showPopup(message: NSLocalizedString("Username copied in clipboard\n\n", comment: "userInClipboard") + site.email!, distanceFromBottom: 125.0)
        break
      
      case #imageLiteral(resourceName: "copy"):
        self.copyInClipboard(text: site.password!)
        dismissAnimation {
          self.dismiss(animated: false, completion: nil)
        }
        rootViewController.showPopup(message: NSLocalizedString("Password copied in clipboard\n\n", comment: "passwordInClipboard") + site.password!, distanceFromBottom: 125.0)
        break
      
      case #imageLiteral(resourceName: "edit"):
        let storyboard = UIStoryboard(name: "Creation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreationView") as! UINavigationController
        let creationController = vc.topViewController as! CreationTableViewController
        creationController.editingSite = site
        dismissAnimation {
          self.dismiss(animated: false) {
            self.rootViewController.present(vc, animated: true, completion: nil)
          }
        }
        break
      
      case #imageLiteral(resourceName: "eye"):
        let alert = UIAlertController(title: NSLocalizedString("Your password is:", comment: "titlePasswordDetail"), message: "", preferredStyle: .alert)
        
        if site.password!.count > 10 {
          let attributedMessage = NSAttributedString(string: site.password!, attributes: [
            NSAttributedStringKey.font : UIFont.italicSystemFont(ofSize: 20)
          ])
          alert.setValue(attributedMessage, forKey: "attributedMessage")
        } else {
          alert.addTextField { textField in
            textField.text = self.site.password
            textField.isEnabled = false
            textField.font = UIFont.italicSystemFont(ofSize: 20.0)
            textField.textAlignment = .center
          }
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Copy Password", comment: "copyPasswordDetail"), style: .default) { _ in
          self.copyInClipboard(text: self.site.password!)
          self.rootViewController.showPopup(message: NSLocalizedString("Password copied in clipboard\n\n", comment: "passwordInClipboard") + self.site.password!, distanceFromBottom: 125.0)
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "okAlertDetail"), style: .cancel, handler: nil))
        
        dismissAnimation {
          self.dismiss(animated: false) {
            self.rootViewController.present(alert, animated: true, completion: nil)
          }
        }
        break
      
      case #imageLiteral(resourceName: "delete"):
        let alert = UIAlertController(title: site.name, message: NSLocalizedString("Are you sure you want to delete?", comment: "confirmMessageDelete"), preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "noAlertDelete"), style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "yesAlertDelete"), style: .default) { _ in
          DataManager.shared.deleteSite(site: self.site) { success in
            if !success {
              self.showAlert(message: NSLocalizedString("Something went wrong, retry later.", comment: "retryLater"), title: NSLocalizedString("Error", comment: "errorAlertDelete"))
            }
          }
        })
        
        dismissAnimation {
          self.dismiss(animated: false) {
            self.rootViewController.present(alert, animated: true, completion: nil)
          }
        }
        break
      
      default:
        break
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1.0
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45.0
  }
  
}
