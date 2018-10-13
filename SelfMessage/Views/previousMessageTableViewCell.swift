//
//  previousMessageTableViewCell.swift
//  SelfMessage
//
//  Created by Emmie Ohnuki on 10/13/18.
//  Copyright © 2018 Emmie Ohnuki. All rights reserved.
//

import Foundation
import UIKit
class previousMessageTableViewCell: UITableViewCell {
    var favoriteButtonTouched: ((UITableViewCell) -> Void)? = nil
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        favoriteButtonTouched?(self)
    }
}
