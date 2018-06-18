//
//  DataManager.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 14/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class DataManager {
  
  public static let shared = DataManager()
  
  let db: Firestore!
  let siteRef: CollectionReference!
  
  var user: User!
  var selectedFolder: String = "(none)"
  
  private init() {
    FirebaseApp.configure()
    db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    
    siteRef = db.collection("Sites")
  }

  func fetchSites(of user: User, completion: @escaping ([Site]?) -> Void) {
    siteRef.whereField("createdBy", isEqualTo: user.uuid).addSnapshotListener { (querySnapshot, error) in
      guard let querySnapshot = querySnapshot else {
        return completion(nil)
      }
  
      var sites = [Site]()
      querySnapshot.documents.forEach({
        guard let site = Site(snapshot: $0) else { return }
        sites.append(site)
      })
      
      completion(sites)
    }
  }
  
  func createSite(user: User, name: String, folder: String, url: String?, email: String?, password: String?, completion: @escaping (Site?) -> Void ) {
    
    let ref = siteRef.document()
    ref.setData([
      "createdBy" : user.uuid,
      "name": name,
      "folder": folder,
      "url": url,
      "email": email,
      "password": password
    ]) { err in
      guard err == nil else { return completion(nil) }
      
      print(ref.documentID)
      let site = Site(uuid: ref.documentID, name: name, folder: folder, url: url, email: email, password: password)
      completion(site)
    }
  }
  
  
}
