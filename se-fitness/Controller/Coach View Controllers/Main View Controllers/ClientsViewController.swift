//
//  ClientsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-21.
//

import UIKit
import Firebase

// MARK: - ClientsViewController

final class ClientsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var clientSelector: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIBarButtonItem!

    // MARK: - Properties

    private var data: [User] = []
    private let firebaseManager = FirebaseManager.shared
    private let dateManager = DateManager.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        loadUserData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.register(UINib(nibName: AppConstants.userCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.userCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
    }

    private func setupUI() {
        welcomeLabel.font = UIFont(name: "calibri-bold", size: 20)
        clientSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12) ?? .systemFont(ofSize: 12)], for: .normal)
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

    private func populateClients() {
        guard let currentUser = Auth.auth().currentUser else { return }
        firebaseManager.fetchUserDocument(uid: currentUser.uid) { [weak self] doc in
            guard let self = self, let safeDoc = doc else { return }
            let athletes = safeDoc.get("athletes") as? [String: [String: Any]] ?? [:]
            for athleteUid in athletes {
                self.firebaseManager.fetchUserDocument(uid: athleteUid.key) { [weak self] athleteDoc in
                    guard let self = self, let safeAthleteDoc = athleteDoc else { return }
                    let athleteFirstName = safeAthleteDoc.get("firstName") as? String ?? ""
                    let athleteLastName = safeAthleteDoc.get("lastName") as? String ?? ""
                    let athleteWorkouts = athletes[athleteUid.key]?["workouts"] as? [String: Any] ?? [:]
                    let workoutDates = self.getClosestWorkouts(athleteWorkouts: athleteWorkouts)
                    self.data.append(User(uid: athleteUid.key, firstName: athleteFirstName, lastName: athleteLastName, lastWorkoutDate: workoutDates[0], nextWorkoutDate: workoutDates[1], lastMessage: nil))
                }
            }
        }
    }

    private func getClosestWorkouts(athleteWorkouts: [String: Any]) -> [Date?] {
        let today = Date()
        var pastWorkout: Date?
        var futureWorkout: Date?

        for athleteWorkout in athleteWorkouts {
            guard let workoutDate = dateManager.convertToDate(
                dateString: athleteWorkout.key,
                stringFormat: "yyyy-MM-dd"
            ) else { continue }

            if workoutDate < today {
                if pastWorkout == nil || workoutDate > pastWorkout! {
                    pastWorkout = workoutDate
                }
            } else if workoutDate > today {
                if futureWorkout == nil || workoutDate < futureWorkout! {
                    futureWorkout = workoutDate
                }
            }
        }
        return [pastWorkout, futureWorkout]
    }
}

// MARK: - UITableViewDataSource

extension ClientsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.userCellIdentifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        let cellData = data[indexPath.row]
        let lastWorkoutText = cellData.lastWorkoutDate.map { dateManager.convertToString(date: $0, stringFormat: "MMMM dd, yyyy") }
        let nextWorkoutText = cellData.nextWorkoutDate.map { dateManager.convertToString(date: $0, stringFormat: "MMMM dd, yyyy") }
        cell.configure(
            name: "\(cellData.firstName) \(cellData.lastName)",
            lastWorkout: lastWorkoutText,
            nextWorkout: nextWorkoutText
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ClientsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
