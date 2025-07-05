//
//  BaseViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-04.
//

import UIKit

class BaseAuthenticationViewController: UIViewController {

    let logoView = UIImageView()
    let height = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogo()
        setupGestures()
    }

    private func setupLogo() {
        logoView.image = UIImage(named: "se-fitness-logo")
        logoView.contentMode = .scaleAspectFit
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)

        // Add layout constraints
        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalToConstant: height * 0.15),
            logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 2),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
