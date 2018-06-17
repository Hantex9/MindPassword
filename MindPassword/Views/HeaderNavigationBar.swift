//
//  HeaderNavigationBar.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 15/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

class HeaderNavigationBar: UINavigationBar {

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let size = CGSize(width: size.width, height: 70.0)
    return size
  }

}
