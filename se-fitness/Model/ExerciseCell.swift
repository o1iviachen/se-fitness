//
//  ExerciseCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-08-20.
//

import UIKit

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var orderLabel: UITextField!
    @IBOutlet weak var exerciseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
