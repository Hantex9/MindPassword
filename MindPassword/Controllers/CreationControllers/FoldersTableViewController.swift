//
//  FoldersTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 17/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class FoldersTableViewController: UITableViewController {
  
  fileprivate let dataManager = DataManager.shared
  
  fileprivate var folders = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("FOLDERS DID LOAD")
    
    if let sites = dataManager.user?.sites {
      print(sites)
      folders = Array(Set(sites.map({ return $0.folder })))
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (section == 0) ? 1 : ((folders.count == 0) ? 1 : folders.count)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = (indexPath.section == 0) ? "newFolderCell" : "folderCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    if indexPath.section != 0 {
      
      guard folders.count != 0 else {
        cell.textLabel?.text = "(none)"
        cell.accessoryType = .checkmark
        return cell
      }
      
      let index = indexPath.row
      
      cell.textLabel?.text = folders[index]
      
      if folders[index] == dataManager.selectedFolder {
        cell.accessoryType = .checkmark
      }

    }

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      let storyboard = UIStoryboard(name: "Creation", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "CreateFolderView")
      navigationController?.pushViewController(vc, animated: true)
    } else {
      dataManager.selectedFolder = (folders.count > 0) ? folders[indexPath.row] : "(none)"
      navigationController?.popToRootViewController(animated: true)
    }
  }
  
  
}
