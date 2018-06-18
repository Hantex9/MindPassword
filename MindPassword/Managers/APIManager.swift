//
//  APIManager.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 18/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
  
  public static let shared = APIManager()
  
  private init() {
    
  }
  
  func downloadImage(url: String, onSuccess: @escaping (UIImage) -> Void, onError: @escaping (Error?) -> Void) -> URLSessionDataTask? {
    
    return request(url: url, method: "GET") { (data, response, error) in
      guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data, error == nil else {
        onError(error)
        return
      }
      if let image = UIImage(data: data) {
        onSuccess(image)
        return
      }
      onError(NSError(domain: "Error while downloading the image", code: 404))
    }
  }
  
  fileprivate func request(url: String, method: String, params: Dictionary<String, Any>? = nil, completition: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
    
    let _encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let _url = URL(string: _encodedURL!)
    print(url)
    var _requestURL = URLRequest(url: _url!)
    _requestURL.httpMethod = method
    if let _body = params {
      _requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
      let jsonData = try? JSONSerialization.data(withJSONObject: _body, options: .prettyPrinted)
      _requestURL.httpBody = jsonData
    }
    
    let session = URLSession.shared.dataTask(with: _requestURL) { (data, response, error) in
      completition(data, response, error)
    }
    session.resume()
    
    return session
  }
}
