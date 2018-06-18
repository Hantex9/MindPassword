//
//  SiteViewCell.swift
//  MindPassword
//
//  Created by Alessandro Izzo on 18/06/18.
//  Copyright © 2018 Alessandro Izzo. All rights reserved.
//

import UIKit

protocol SiteViewCellDelegate {
  func didCopy(from cell: SiteViewCell)
}

class SiteViewCell: UITableViewCell {

  @IBOutlet weak var previewImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var copyButton: UIButton!
  
  var delegate: SiteViewCellDelegate?
  
  
  /// - MARK: Actions
  @IBAction func copyButtonPressed(_ sender: UIButton) {
    delegate?.didCopy(from: self)
  }
  

}
