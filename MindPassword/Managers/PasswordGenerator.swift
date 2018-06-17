//
//  PasswordGenerator.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 16/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import Foundation

class PasswordGenerator {
  
  public static let shared = PasswordGenerator()
  
  
  var numberOfCharacters: Int = 8 {
    didSet {
      var numChars = min(numberOfCharacters, 16)
      numChars = max(numberOfCharacters, 1)
      self.numberOfCharacters = numChars
    }
  }
  var useLetters: Bool = true
  var useNumbers: Bool = true
  var useCapitalLetters: Bool = true
  var useSpecialCharacters: Bool = true
  
  fileprivate let letters = "abcdefghijklmnopqrstuvwxyz"
  fileprivate let specialCharacters = "!$%@#"
  fileprivate let numbers = "0123456789"
  
  private init() {
    
  }
  
  func generate() -> String {

    var universe: String = ""
    
    if useLetters {
      universe += letters
    }
    if useNumbers {
      universe += numbers
    }
    if useSpecialCharacters {
      universe += specialCharacters
    }
    if useCapitalLetters{
      universe += letters.uppercased()
    }
    
    guard !universe.isEmpty else { return "" }
    
    let universeArray = Array(universe)
    
    var generatedPassword = ""
    generatedPassword = String((0..<numberOfCharacters).map{ _ in
      universeArray[Int(arc4random_uniform(UInt32(universe.count)))]
    })
    
    return generatedPassword
  }
}

