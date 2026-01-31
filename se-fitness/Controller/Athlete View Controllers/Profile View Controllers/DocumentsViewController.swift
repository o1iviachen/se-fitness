//
//  DocumentsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-19.
//

import UIKit
import Firebase

// MARK: - DocumentsViewController

final class DocumentsViewController: BaseProfileViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let data: [Document] = [Document(title: "Mobility routine", comment: "Once a day!", pdfTitle: "mobility.pdf")]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        viewControllerLabel.text = "📄 Documents"
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: AppConstants.documentCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.documentCellIdentifier)
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

extension DocumentsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.documentCellIdentifier, for: indexPath) as? DocumentCell else {
            return UITableViewCell()
        }
        let cellData = data[indexPath.row]
        cell.configure(title: cellData.title, comment: cellData.comment, pdfTitle: cellData.pdfTitle)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DocumentsViewController: UITableViewDelegate {

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


