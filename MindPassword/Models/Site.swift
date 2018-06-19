//
//  Site.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 18/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Site {
  let uuid: String!
  let createdBy: String!
  var name: String!
  var folder: String!
  var url: String?
  var email: String?
  var password: String?
  
  init(uuid: String, createdBy: String, name: String, folder: String, url: String?, email: String?, password: String?) {
    self.uuid = uuid
    self.name = name
    self.createdBy = createdBy
    self.folder = folder
    self.url = url
    self.email = email
    self.password = password
  }
  
  init?(snapshot: DocumentSnapshot) {
    guard let value = snapshot.data() else { return nil}
    let uuid = snapshot.documentID
    
    guard
      let name = value["name"] as? String,
      let createdBy = value["createdBy"] as? String,
      let folder = value["folder"] as? String else {
        return nil
    }
    
    let url = value["url"] as? String
    let email = value["email"] as? String
    let password = value["password"] as? String
    
    self.uuid = uuid
    self.createdBy = createdBy
    self.name = name
    self.folder = folder
    self.url = url
    self.email = email
    self.password = password
  }
  
  func toDictionary() -> [String: Any?] {
    return [
      "createdBy": createdBy,
      "name": name,
      "folder": folder,
      "url": url,
      "email": email,
      "password": password
    ]
  }
}
