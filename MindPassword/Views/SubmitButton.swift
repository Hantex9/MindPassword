//
//  SubmitButton.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class SubmitButton: UIButton {
  
  private let activityIndicator: UIActivityIndicatorView = {
    let activity = UIActivityIndicatorView()
    activity.translatesAutoresizingMaskIntoConstraints = false
    activity.isHidden = true
    return activity
  }()
  
  var isFetchingData: Bool = false {
    didSet {
      self.isEnabled = !isFetchingData
      activityIndicator.isHidden = !isFetchingData
      if isFetchingData {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.layer.cornerRadius = self.frame.size.height / 2
    self.layer.masksToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupActivityIndicator()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupActivityIndicator()
  }
  
  fileprivate func setupActivityIndicator() {
    addSubview(activityIndicator)

    NSLayoutConstraint.activate([
      activityIndicator.widthAnchor.constraint(equalToConstant: 20.0),
      activityIndicator.heightAnchor.constraint(equalToConstant: 20.0),
      activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }

}
