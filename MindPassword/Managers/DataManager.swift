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
import LocalAuthentication

class DataManager {
  
  public static let shared = DataManager()
  
  let db: Firestore!
  let siteRef: CollectionReference!
  let userDefaults = UserDefaults.standard
  
  var isNewUser: Bool = false
  
  var rememberedEmail: String? {
    get {
      return userDefaults.string(forKey: "rememberedEmail")
    }
    set {
      userDefaults.set(newValue, forKey: "rememberedEmail")
      userDefaults.synchronize()
    }
  }
  
  var rememberedPassword: String? {
    get {
      return userDefaults.string(forKey: "rememberedPassword")
    }
    set {
      userDefaults.set(newValue, forKey: "rememberedPassword")
      userDefaults.synchronize()
    }
  }
  
  var isTouchIDEnabled: Bool? {
    get {
      return userDefaults.bool(forKey: "isTouchIDEnabled")
    }
    set {
      userDefaults.set(newValue, forKey: "isTouchIDEnabled")
      userDefaults.synchronize()
    }
  }
  
  var user: User!
  var selectedFolder: String = "(none)"
  
  private init() {
    
    userDefaults.register(defaults: ["rememberedEmail": "",
                                     "rememberedPassword": "",
                                     "isTouchIDEnabled": false])
    
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
      let site = Site(uuid: ref.documentID, createdBy: user.uuid, name: name, folder: folder, url: url, email: email, password: password)
      completion(site)
    }
  }
  
  func updateSite(site: Site, name: String, folder: String, url: String?, email: String?, password: String?, completion: @escaping (Bool) -> Void) {
    let ref = siteRef.document(site.uuid)
    ref.updateData([
      "name": name,
      "folder": folder,
      "url": url,
      "email": email,
      "password": password
    ]) { err in
      guard err == nil else { return completion(false) }
      
      print(ref.documentID)
      completion(true)
    }
  }
  
  func deleteSite(site: Site, completion: @escaping (Bool) -> Void) {
    let ref = siteRef.document(site.uuid)
    ref.delete { (error) in
      guard error == nil else{ return completion(false) }
      completion(true)
    }
  }
  
}
