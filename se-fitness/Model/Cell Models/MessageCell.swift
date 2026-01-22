//
//  TextCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-21.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        profileImageView.layer.cornerRadius = 20
        recipientLabel.font = UIFont(name: "calibri-bold", size: 17)
        messageLabel.font = UIFont(name: "calibri", size: 15)
    }
}
