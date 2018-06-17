//
//  FoldersTableViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 17/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class FoldersTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return (section == 0) ? 1 : DataManager.shared.user.folders.count
    return (section == 0) ? 1 : 4
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = (indexPath.section == 0) ? "newFolderCell" : "folderCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
//    cell.textLabel = DataManager.shared.user.folders[indexPath.row]
    
//    if DataManager.shared.user.folders[indexPath.row] == DataManager.shared.user.selectedFolder {
//      cell.accessoryType = .checkmark
//    }
    
    if DataManager.shared.folder == cell.textLabel!.text {
      cell.accessoryType = .checkmark
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      let storyboard = UIStoryboard(name: "Creation", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "CreateFolderView")
      navigationController?.pushViewController(vc, animated: true)
    } else {
//      DataManager.shared.user.selectedFolder = DataManager.shared.user.folders[indexPath.row]
      DataManager.shared.folder = tableView.cellForRow(at: indexPath)?.textLabel!.text!
      navigationController?.popToRootViewController(animated: true)
    }
  }
  
  
}
