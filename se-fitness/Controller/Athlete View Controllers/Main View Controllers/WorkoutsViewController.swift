//
//  WorkoutsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit
import Firebase

// MARK: - WorkoutsViewController

final class WorkoutsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerBlock: UIView!
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var workoutSelector: UISegmentedControl!
    @IBOutlet private weak var monthSelector: UIView!
    @IBOutlet private weak var targetViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var leftButton: NSLayoutConstraint!

    // MARK: - Properties

    private let data = [Workout(completionImage: UIImage(systemName: "checkmark.circle") ?? UIImage(), date: Date(), workoutText: "Thursday", exercises: [Exercise(orderText: "A", exerciseName: "Squats", descriptionText: "3x8")])]
    private var filteredData: [Workout] = []
    private let dateManager = DateManager.shared
    private let firebaseManager = FirebaseManager.shared
    private var currentDate = Date()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
        setupTableView()
    }

    // MARK: - IBActions

    @IBAction private func timeSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            monthSelector.isHidden = true
            targetViewHeightConstraint.constant = 0
        } else {
            monthSelector.isHidden = false
            targetViewHeightConstraint.constant = 60
        }
        updateFilteredData()
        tableView.reloadData()
    }

    @IBAction private func nextMonth(_ sender: UIButton) {
        if !Calendar.current.isDate(currentDate, equalTo: Date(), toGranularity: .month) {
            guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else { return }
            currentDate = newDate
            monthLabel.text = dateManager.convertToString(date: currentDate, stringFormat: "MMMM yyyy")
            updateFilteredData()
            tableView.reloadData()
        }
    }

    @IBAction private func pastMonth(_ sender: UIButton) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) else { return }
        currentDate = newDate
        monthLabel.text = dateManager.convertToString(date: currentDate, stringFormat: "MMMM yyyy")
        updateFilteredData()
        tableView.reloadData()
    }

    // MARK: - Private Methods

    private func setupUI() {
        workoutSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12) ?? .systemFont(ofSize: 12)], for: .normal)
        monthLabel.font = UIFont(name: "calibri", size: 17) ?? .systemFont(ofSize: 17)
        monthLabel.text = dateManager.convertToString(date: currentDate, stringFormat: "MMMM yyyy")
        welcomeLabel.font = UIFont(name: "calibri-bold", size: 20)
        welcomeLabel.sizeToFit()
        targetViewHeightConstraint.constant = 0
    }

    private func loadUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        firebaseManager.getUserData(uid: currentUser.uid, value: "firstName") { [weak self] firstName in
            guard let self = self else { return }
            if let firstName = firstName {
                self.welcomeLabel.text = "Hey, \(firstName) 👋"
            } else {
                self.welcomeLabel.text = "Hey! 👋"
            }
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AppConstants.workoutCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.workoutCellIdentifier)
        tableView.backgroundColor = .systemGray6
        updateFilteredData()
        tableView.reloadData()
    }

    private func updateFilteredData() {
        if workoutSelector.selectedSegmentIndex == 0 {
            filteredData = data.filter { $0.date >= dateManager.todayAtMidnight() }
        } else {
            filteredData = data.filter {
                Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .month) &&
                Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .year)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension WorkoutsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.workoutCellIdentifier, for: indexPath) as? WorkoutCell else {
            return UITableViewCell()
        }
        let cellData = filteredData[indexPath.section]
        cell.configure(
            workoutText: cellData.workoutText,
            completionImage: cellData.completionImage,
            dateText: dateManager.convertToString(date: cellData.date, stringFormat: "MMMM dd, yyyy"),
            exercises: cellData.exercises
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WorkoutsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
