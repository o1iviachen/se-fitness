//
//  UserCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-26.
//

import UIKit

// MARK: - UserCell

final class UserCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var lastWorkoutLabel: UILabel!
    @IBOutlet private weak var nextWorkoutLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastWorkoutButton: UIButton!
    @IBOutlet private weak var nextWorkoutButton: UIButton!
    @IBOutlet private weak var userOptionsButton: UIButton!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont(name: "calibri-bold", size: 17)
        let dateLabels: [UILabel] = [lastWorkoutLabel, nextWorkoutLabel]
        for dateLabel in dateLabels {
            dateLabel.font = UIFont(name: "calibri", size: 15)
        }
        let workoutButtons: [UIButton] = [lastWorkoutButton, nextWorkoutButton]
        for workoutButton in workoutButtons {
            workoutButton.titleLabel?.font = UIFont(name: "calibri", size: 12)
            workoutButton.layer.cornerRadius = 12
        }
    }

    // MARK: - Public Methods

    func configure(name: String, lastWorkout: String?, nextWorkout: String?) {
        nameLabel.text = name
        if let lastWorkout = lastWorkout {
            lastWorkoutButton.setTitle(lastWorkout, for: .normal)
        }
        if let nextWorkout = nextWorkout {
            nextWorkoutButton.setTitle(nextWorkout, for: .normal)
        }
    }
}
