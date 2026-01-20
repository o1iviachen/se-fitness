//
//  ProfileCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-06.
//

import UIKit

class ProfileCell: UITableViewCell {

    /**
         A custom UITableViewCell subclass that displays the user's profile information.
         
         - Properties:
            - label (Unwrapped UILabel): Displays text.
            - iconImage (Unwrapped UIImageView): Displays an icon image.
         */

        @IBOutlet weak var label: UILabel!
        @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = UIFont(name: "calibri", size: 17)
    }
}
