//
//  ProfileViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit
import Firebase

// MARK: - ProfileViewController

final class ProfileViewController: BaseProfileViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let data: [[Any]] = [
        [
            Setting(image: UIImage(systemName: "figure.indoor.soccer") ?? UIImage(), setting: "Goals"),
            Setting(image: UIImage(systemName: "list.clipboard") ?? UIImage(), setting: "Documents")
        ],
        [
            Setting(image: UIImage(systemName: "person.fill") ?? UIImage(), setting: "Personal information"),
            Setting(image: UIImage(systemName: "questionmark.message") ?? UIImage(), setting: "Contact")
        ],
        ["Log out"]
    ]
    private let alertManager = AlertManager.shared
    private let firebaseManager = FirebaseManager.shared
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserRole()
        setupTableView()
    }

    // MARK: - Private Methods

    private func loadUserRole() {
        guard let currentUser = Auth.auth().currentUser else { return }
        firebaseManager.getUserData(uid: currentUser.uid, value: "role") { [weak self] role in
            guard let self = self else { return }
            let roleString = role as? String ?? ""
            if roleString == "coach" {
                self.firebaseManager.getUserData(uid: currentUser.uid, value: "coachId") { [weak self] coachCode in
                    guard let self = self else { return }
                    self.viewControllerLabel.text = "🏆 Your code: \(coachCode ?? "error")"
                }
            } else {
                self.firebaseManager.getUserData(uid: currentUser.uid, value: "workoutsCompleted") { [weak self] numberOfWorkouts in
                    guard let self = self else { return }
                    self.viewControllerLabel.text = "🏆 \(numberOfWorkouts ?? 0) workouts completed"
                }
            }
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: AppConstants.profileCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.profileCellIdentifier)
        tableView.register(UINib(nibName: AppConstants.logOutCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.logOutCellIdentifier)
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

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellData = data[indexPath.section][indexPath.row] as? Setting {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.profileCellIdentifier, for: indexPath) as? ProfileCell else {
                return UITableViewCell()
            }
            cell.configure(setting: cellData.setting, image: cellData.image)
            return cell
        } else {
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: AppConstants.logOutCellIdentifier, for: indexPath)
            return logOutCell
        }
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [2, 0] {
            showLogoutAlert()
        } else if indexPath == [0, 0] {
            performSegue(withIdentifier: AppConstants.profileGoalSegue, sender: self)
        } else if indexPath == [0, 1] {
            performSegue(withIdentifier: AppConstants.profileDocumentSegue, sender: self)
        } else if indexPath == [1, 1] {
            performSegue(withIdentifier: AppConstants.profileContactSegue, sender: self)
        }
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

    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let logOutAction = UIAlertAction(title: "Log out", style: .default) { [weak self] _ in
            guard let self = self else { return }
            do {
                try Auth.auth().signOut()
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let delegate = windowScene.delegate as? SceneDelegate,
                   let window = delegate.window {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let welcomeVC = storyboard.instantiateViewController(withIdentifier: AppConstants.welcomeIdentifier)
                    window.rootViewController = welcomeVC
                    window.makeKeyAndVisible()
                }
            } catch let signOutError as NSError {
                self.alertManager.showAlert(alertMessage: signOutError.localizedDescription, viewController: self)
            }
        }
        logOutAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(logOutAction)
        present(alert, animated: true, completion: nil)
    }
}
