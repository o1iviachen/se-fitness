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
        
        orderLabel.font = UIFont(name: "calibri-bold", size: 15)
        exerciseName.font = UIFont(name: "calibri", size: 15)
    }
}
