//
//  WorkoutCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-13.
//

import UIKit

// MARK: - WorkoutCell

final class WorkoutCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var exerciseTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var completionImage: UIImageView!
    @IBOutlet private weak var workoutLabel: UILabel!
    @IBOutlet private weak var exerciseTable: UITableView!

    // MARK: - Properties

    private var data: [Exercise] = [] {
        didSet {
            exerciseTable.reloadData()
            let rowHeight = 45
            exerciseTableHeightConstraint.constant = CGFloat(data.count * rowHeight)
        }
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        let labels: [UILabel] = [dateLabel, workoutLabel]
        for label in labels {
            label.font = UIFont(name: "calibri", size: 17)
        }

        exerciseTable.register(UINib(nibName: AppConstants.exerciseCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.exerciseCellIdentifier)
        exerciseTable.dataSource = self
        exerciseTable.delegate = self
    }

    // MARK: - Public Methods

    func configure(workoutText: String, completionImage: UIImage, dateText: String, exercises: [Exercise]) {
        workoutLabel.text = workoutText
        self.completionImage.image = completionImage
        dateLabel.text = dateText
        data = exercises
    }
}

// MARK: - UITableViewDataSource

extension WorkoutCell: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.exerciseCellIdentifier, for: indexPath) as? ExerciseCell else {
            return UITableViewCell()
        }
        let cellData = data[indexPath.row]
        cell.configure(orderText: cellData.orderText, exerciseName: cellData.exerciseName)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WorkoutCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

