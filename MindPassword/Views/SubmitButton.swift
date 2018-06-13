//
//  SubmitButton.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 13/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class SubmitButton: UIButton {

  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.layer.cornerRadius = self.frame.size.height / 2
    self.layer.masksToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
