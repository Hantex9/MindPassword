//
//  HomeViewController.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 15/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate let dataManager = DataManager.shared
  fileprivate var folders = [String]()
  fileprivate var foldersSites: [String: [Site]] = [:]
  fileprivate var imagesSite: [String: [UIImage]] = [:]
  
  var hasLoggedIn: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    self.setObservers()
    
    let topViewController = getTopViewController()
    if !hasLoggedIn && !dataManager.isNewUser && !(topViewController is IdentificationViewController) && !(topViewController is IdentificationPasswordViewController) {
      let storyboard = UIStoryboard(name: "Identification", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "IdentificationView") as! IdentificationViewController
      topViewController.present(vc, animated: false, completion: nil)
      vc.showTouchID()
    }
    
    dataManager.isNewUser = false
  }
  
  fileprivate func setObservers() {
    dataManager.fetchSites(of: dataManager.user!) { (sites) in
      guard let sites = sites else { return }
      self.dataManager.user.sites = sites.reversed()
      
      self.folders = Array(Set(self.dataManager.user.sites!.map({ return $0.folder })))
      
      self.foldersSites.forEach{ (key: String, _) in
        self.foldersSites[key] = []
      }
      
      self.imagesSite.forEach({ (key: String, _) in
        self.imagesSite[key] = []
      })
      
      self.dataManager.user.sites?.forEach({
        if self.foldersSites[$0.folder] == nil {
          self.foldersSites[$0.folder] = []
        }
        if self.imagesSite[$0.folder] == nil {
          self.imagesSite[$0.folder] = []
        }
        self.foldersSites[$0.folder]!.append($0)
        self.imagesSite[$0.folder]!.append(self.createPreviewImage(from: $0.name))
      })
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  
  }
  
  fileprivate func createPreviewImage(from text: String) -> UIImage {
    let lblNameInitialize = UILabel()
    lblNameInitialize.frame.size = CGSize(width: 150, height: 100)
    lblNameInitialize.textColor = UIColor.gray
    lblNameInitialize.text = String(text.first!).uppercased()
    lblNameInitialize.font = UIFont.boldSystemFont(ofSize: 26.0)
    lblNameInitialize.textAlignment = .center
    lblNameInitialize.backgroundColor = UIColor.clear
    
    let circleView = UIView()
    circleView.frame.size = CGSize(width: 40.0, height: 40.0)
    circleView.layer.masksToBounds = true
    circleView.backgroundColor = UIColor.clear
    circleView.layer.borderColor = UIColor.gray.cgColor
    circleView.layer.borderWidth = 1.0
    circleView.layer.cornerRadius = 20.0
    
    lblNameInitialize.addSubview(circleView)
    
    circleView.center = lblNameInitialize.center
    
    UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(1.0)
    context?.setStrokeColor(UIColor.gray.cgColor)
    context?.move (to: CGPoint(x: 0, y: 50))
    context?.addLine (to: CGPoint(x: 50.0, y: 50))
    context?.strokePath()
    
    context?.move (to: CGPoint(x: 100, y: 50))
    context?.addLine (to: CGPoint(x: 150, y: 50))
    context?.strokePath()
    
    lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
  // MARK: Actions
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
  }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return folders.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let folder = foldersSites[folders[section]] else { return 0 }
    return (!folder.isEmpty) ? folder.count : 0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let localSites = foldersSites[folders[indexPath.section]] else { return }
    let site = localSites[indexPath.row]
    let storyboard = UIStoryboard(name: "Home", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "OptionsView") as! OptionsViewController

    vc.site = site
    vc.modalPresentationStyle = .overCurrentContext
    vc.modalTransitionStyle = .crossDissolve
    vc.rootViewController = self
    tabBarController?.present(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "siteCell") as! SiteViewCell
    let index = indexPath.row
    
    let foldersGrouped = foldersSites[folders[indexPath.section]]
    guard let site = foldersGrouped?[index] else { return cell }
    let images = imagesSite[folders[indexPath.section]]
    
    cell.delegate = self
    
    cell.nameLabel.text = site.name
    cell.emailLabel.text = site.email
    cell.copyButton.isHidden = (site.password == nil)
    cell.previewImageView.image = images?[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return folders[section]
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
  {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.font = UIFont.systemFont(ofSize: 18)
    header.textLabel?.text = folders[section]
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1.0
  }
}


/// - MARK: SiteViewCellDelegate
extension HomeViewController: SiteViewCellDelegate {
  func didCopy(from cell: SiteViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    guard let sites = foldersSites[folders[indexPath.section]] else { return }
    guard let password = sites[indexPath.row].password else { return }
    self.copyInClipboard(text: password)
    self.showPopup(message: NSLocalizedString("Password copied in clipboard\n\n", comment: "passwordInClipboard") + password, distanceFromBottom: 125.0)
  }
  
  
}
