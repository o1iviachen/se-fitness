//
//  TabBarController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-04.
//

import Foundation
import UIKit

// MARK: - TabBarController

class TabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupTabBarFont()
    }

    // MARK: - Private Methods

    private func setupTabBarFont() {
        guard let items = tabBar.items else { return }
        let font = UIFont(name: "calibri", size: 10) ?? .systemFont(ofSize: 10)
        for item in items {
            item.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
    }
}
