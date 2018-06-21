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
  
  let searchController = UISearchController(searchResultsController: nil)
  
  fileprivate let dataManager = DataManager.shared
  fileprivate var folders = [String]()
  fileprivate var foldersSites: [String: [Site]] = [:]
  fileprivate var filteredSites: [String: [Site]] = [:]
  fileprivate var filteredFolders: [String] = []
  
  var hasLoggedIn: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    setupSearchBar()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    tapGesture.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tapGesture)
    
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
  
  @objc func tapHandler() {
    self.view.endEditing(true)
  }
  
  fileprivate func setupSearchBar() {
    
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.tintColor = .white
    if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
      textfield.textColor = UIColor.blue
      if let backgroundview = textfield.subviews.first {
        
        backgroundview.backgroundColor = UIColor.white
        
        backgroundview.layer.cornerRadius = 10;
        backgroundview.clipsToBounds = true;
        
      }
    }
    searchController.searchBar.placeholder = "Search Sites"
    navigationItem.searchController = searchController
  }
  
  fileprivate func isFiltering() -> Bool {
    return searchController.isActive && !searchBarIsEmpty()
  }
  
  fileprivate func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  fileprivate func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    
    let filteredSites = dataManager.user.sites?.filter({ (site) -> Bool in
      return site.name.lowercased().contains(searchText.lowercased())
    })

    filteredFolders = Array(Set(filteredSites!.map { return $0.folder} ))
    
    self.filteredSites.removeAll()

    filteredSites?.forEach {
      if self.filteredSites[$0.folder] == nil {
        self.filteredSites[$0.folder] = []
      }
      self.filteredSites[$0.folder]!.append($0)
      self.filteredSites[$0.folder]![self.filteredSites[$0.folder]!.count - 1].image = self.createPreviewImage(from: $0.name)
    }
    
    tableView.reloadData()
  }
  
  fileprivate func setObservers() {
    dataManager.fetchSites(of: dataManager.user!) { (sites) in
      guard let sites = sites else { return }
      
      self.dataManager.user.sites = sites.reversed()
      
      self.folders = Array(Set(self.dataManager.user.sites!.map({ return $0.folder })))
      
      self.foldersSites.forEach{ (key: String, _) in
        self.foldersSites[key] = []
      }
      
      
      self.dataManager.user.sites?.forEach({
        if self.foldersSites[$0.folder] == nil {
          self.foldersSites[$0.folder] = []
        }
        
        self.foldersSites[$0.folder]!.append($0)
        self.foldersSites[$0.folder]![self.foldersSites[$0.folder]!.count - 1].image = self.createPreviewImage(from: $0.name)
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
    return isFiltering() ? filteredFolders.count : folders.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    guard let folder = isFiltering() ? filteredSites[filteredFolders[section]] : foldersSites[folders[section]] else { return 0 }
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
    
    let foldersGrouped = (!isFiltering()) ? foldersSites[folders[indexPath.section]] : filteredSites[filteredFolders[indexPath.section]]
    guard let site = foldersGrouped?[index] else { return cell }

    cell.delegate = self
    
    cell.nameLabel.text = site.name
    cell.emailLabel.text = site.email
    cell.copyButton.isHidden = (site.password == nil)
    cell.previewImageView.image = site.image
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return isFiltering() ? filteredFolders[section] : folders[section]
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
  {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.font = UIFont.systemFont(ofSize: 18)
    header.textLabel?.text = isFiltering() ? filteredFolders[section] : folders[section]
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

/// - MARK: SearchBarResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
