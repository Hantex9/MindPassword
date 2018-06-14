//
//  CredentialsTextField.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class CredentialsTextField: UITextField {
  
  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.lightGray
    return label
  }()
  
  fileprivate let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5);
  fileprivate var placeholderText: String?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    delegate = self
    placeholderLabel.text = placeholder
    placeholderText = placeholder
    
    placeholder = ""
    
    let point = CGPoint(x: padding.left, y: 0.0)
    placeholderLabel.frame = CGRect(origin: point, size: frame.size)
    addSubview(placeholderLabel)
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  fileprivate func animateLabel(label: UILabel, to point: CGPoint, duration: Double, finalColor: UIColor, completion: @escaping () -> Void) {

    UIView.animate(withDuration: duration, animations: {
      label.frame.origin = point
    }) { _ in
      label.textColor = finalColor
      completion()
    }
  }
  
}

extension CredentialsTextField: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    let pointToMove = CGPoint(x: placeholderLabel.frame.origin.x, y: -20)
    self.placeholder = ""
    self.animateLabel(label: self.placeholderLabel, to: pointToMove, duration: 0.3, finalColor: UIColor.black) {
      self.placeholderText = self.placeholder
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = self.text, text.isEmpty {
      
      let pointToMove = CGPoint(x: placeholderLabel.frame.origin.x, y: 0)
      self.animateLabel(label: self.placeholderLabel, to: pointToMove, duration: 0.3, finalColor: UIColor.lightGray) {
        self.placeholderText = self.placeholder
      }
    }
  }
}
