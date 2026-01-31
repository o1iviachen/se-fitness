//
//  GoalsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-19.
//

import UIKit
import Firebase

// MARK: - GoalsViewController

final class GoalsViewController: BaseProfileViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let data: [Goal] = [Goal(title: "Squat 1RM", description: "225 pounds")]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        viewControllerLabel.text = "🚀 Goals"
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: AppConstants.goalCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.goalCellIdentifier)
        tableView.backgroundColor = .systemGray6
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: blockView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension GoalsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.goalCellIdentifier, for: indexPath) as? GoalCell else {
            return UITableViewCell()
        }
        let cellData = data[indexPath.row]
        cell.configure(title: cellData.title, description: cellData.description)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GoalsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}


