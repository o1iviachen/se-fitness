//
//  BaseProfileViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-19.
//

import Firebase
import UIKit

class BaseProfileViewController: UIViewController {

    let firebaseManager = FirebaseManager()
    let blockView = UIView()
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
        label.font = UIFont(name: "calibri-bold", size: 22)!
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    let viewControllerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "calibri", size: 15)!
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    let height = UIScreen.main.bounds.height

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlock()
    }

    private func setupBlock() {
        blockView.backgroundColor = UIColor(named: "dark-grey")!
        blockView.contentMode = .scaleAspectFit
        blockView.translatesAutoresizingMaskIntoConstraints = false

        firebaseManager.getUserData(
            uid: Auth.auth().currentUser!.uid,
            value: "firstName",
            completion: { firstName in
                self.firebaseManager.getUserData(
                    uid: Auth.auth().currentUser!.uid,
                    value: "lastName",
                    completion: { lastName in
                        self.userNameLabel.text =
                            "\(firstName ?? "") \(lastName ?? "")"
                    }
                )
            }
        )
        
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
