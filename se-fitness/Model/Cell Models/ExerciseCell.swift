//
//  ExerciseCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-08-20.
//

import UIKit

// MARK: - ExerciseCell

final class ExerciseCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var orderLabel: UITextField!
    @IBOutlet private weak var exerciseName: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        orderLabel.font = UIFont(name: "calibri-bold", size: 15)
        exerciseName.font = UIFont(name: "calibri", size: 15)
    }

    // MARK: - Public Methods

    func configure(orderText: String, exerciseName: String) {
        orderLabel.text = orderText
        self.exerciseName.text = exerciseName
    }
}
