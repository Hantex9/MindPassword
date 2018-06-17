//
//  GeneratedPasswordView.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 16/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class GeneratedPasswordView: UIView {
  
  @IBOutlet weak var generatedPasswordLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  fileprivate func setup() {
    self.layer.borderColor = UIColor.gray.cgColor
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 5.0
    self.layer.borderWidth = 1.0
  }

}
