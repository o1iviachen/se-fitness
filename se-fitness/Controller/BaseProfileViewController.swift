//
//  BaseProfileViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-19.
//

import Firebase
import UIKit

// MARK: - BaseProfileViewController

class BaseProfileViewController: UIViewController {

    // MARK: - Properties

    let blockView = UIView()
    let viewControllerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "calibri", size: 15) ?? .systemFont(ofSize: 15)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private let firebaseManager = FirebaseManager.shared
    private let height = UIScreen.main.bounds.height

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "test-monkey")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
        ])
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "calibri-bold", size: 22) ?? .boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userNameLabel,
            viewControllerLabel,
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var profileStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            profileImageView,
            textStackView,
        ])
        stack.axis = .horizontal
        stack.spacing = 25
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlock()
    }

    // MARK: - Private Methods

    private func setupBlock() {
        blockView.backgroundColor = UIColor(named: "dark-grey") ?? .darkGray
        blockView.contentMode = .scaleAspectFit
        blockView.translatesAutoresizingMaskIntoConstraints = false

        guard let currentUser = Auth.auth().currentUser else { return }

        firebaseManager.getUserData(
            uid: currentUser.uid,
            value: "firstName"
        ) { [weak self] firstName in
            guard let self = self else { return }
            self.firebaseManager.getUserData(
                uid: currentUser.uid,
                value: "lastName"
            ) { [weak self] lastName in
                guard let self = self else { return }
                self.userNameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
            }
        }

        blockView.addSubview(profileStackView)
        view.addSubview(blockView)

        // Add layout constraints
        NSLayoutConstraint.activate([
            blockView.heightAnchor.constraint(equalToConstant: height * 0.2),
            blockView.topAnchor.constraint(equalTo: view.topAnchor),
            blockView.leftAnchor.constraint(equalTo: view.leftAnchor),
            blockView.rightAnchor.constraint(equalTo: view.rightAnchor),
            profileStackView.centerXAnchor.constraint(equalTo: blockView.centerXAnchor),
            profileStackView.bottomAnchor.constraint(equalTo: blockView.bottomAnchor, constant: -15),
            profileStackView.leftAnchor.constraint(equalTo: blockView.leftAnchor, constant: 40),
        ])
    }
}
