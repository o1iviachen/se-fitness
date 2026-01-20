//
//  GoalViewCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-19.
//

import UIKit

class GoalCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "calibri-bold", size: 17)
        descriptionLabel.font = UIFont(name: "calibri", size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
