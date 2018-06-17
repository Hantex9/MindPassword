//
//  CredentialsTextField.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

protocol CredentialsTextFieldDelegate: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class CredentialsTextField: UITextField {
  
  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.lightGray
    return label
  }()
  
  public let errorMessageLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let bottomBorder = CALayer()
  
  fileprivate let padding = UIEdgeInsets(top: 0, left: 10, bottom: -10, right: 5)
  fileprivate var placeholderText: String?
  
  var borderColor: UIColor = .gray {
    didSet {
      self.bottomBorder.backgroundColor = borderColor.cgColor
    }
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
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
  
  fileprivate func setup() {
    self.delegate = self
    createPlaceholder()
    showBottomBorder(color: UIColor.gray, borderWidth: 1.0)
    
    self.font = UIFont.italicSystemFont(ofSize: 17.0)
    
  }
  
  func showErrorMessage(message: String, errorColor: UIColor = .red) {
    bottomBorder.removeFromSuperlayer()
    showBottomBorder(color: errorColor, borderWidth: 1.5)
    
    self.addSubview(errorMessageLabel)

    let constraints = [
      errorMessageLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
      errorMessageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left),
      errorMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ]
    
    NSLayoutConstraint.deactivate(constraints)
    NSLayoutConstraint.activate(constraints)
    
    errorMessageLabel.text = message
    errorMessageLabel.textColor = errorColor
    errorMessageLabel.sizeToFit()
    errorMessageLabel.alpha = 0.0
    
    UIView.animate(withDuration: 0.2) {
      self.errorMessageLabel.alpha = 1.0
    }
  }
  
  func dismissErrorMessage() {

    self.errorMessageLabel.text = ""
    self.bottomBorder.backgroundColor = UIColor.gray.cgColor
  }
  
  func showBottomBorder(color: UIColor, borderWidth: CGFloat = 1.0) {
    
    bottomBorder.frame = CGRect(x: padding.left, y: self.frame.size.height - borderWidth - 5, width: self.frame.size.width - padding.left*2 , height: borderWidth)
    bottomBorder.backgroundColor = color.cgColor
    self.layer.addSublayer(bottomBorder)
  }
  
  func hideBottomBorder() {
    
    bottomBorder.removeFromSuperlayer()
  }
  
  fileprivate func createPlaceholder() {
    placeholderLabel.text = placeholder
    placeholderText = placeholder
    
    placeholder = ""
    
    let point = CGPoint(x: padding.left, y: 0.0)
    placeholderLabel.frame = CGRect(origin: point, size: frame.size)
    self.addSubview(placeholderLabel)
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
    self.animateLabel(label: self.placeholderLabel, to: pointToMove, duration: 0.2, finalColor: UIColor(red: 58/255, green: 50/255, blue: 46/255, alpha: 1.0)) {
      self.placeholderText = self.placeholder
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = self.text, text.isEmpty {
      
      let pointToMove = CGPoint(x: placeholderLabel.frame.origin.x, y: 0)
      self.animateLabel(label: self.placeholderLabel, to: pointToMove, duration: 0.2, finalColor: UIColor.lightGray) {
        self.placeholderText = self.placeholder
      }
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {    
    endEditing(true)
    return true
  }
}
