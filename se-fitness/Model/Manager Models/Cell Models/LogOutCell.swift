//
//  LogOutCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-07.
//

import UIKit

class LogOutCell: UITableViewCell {

    @IBOutlet weak var logOutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logOutLabel.font = UIFont(name: "calibri", size: 17)
    }
    
}
