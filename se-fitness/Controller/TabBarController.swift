//
//  TabBarController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-04.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    /**
     A class that allows the Tab Bar Controller to be hidden and shown.
     */
    
    
    override func viewWillAppear(_ animated: Bool) {
        /**
         Called just before the Tab Bar Controller is loaded and overrides the default behaviour to hide the Tab Bar Controller.
         
         - Parameters:
            - animated (Bool): Indicates if the appearance is animated.
         */
        
        super.viewWillAppear(animated)
        
        // Hide navigation button upon completing authentication
        navigationController?.setNavigationBarHidden(true, animated: true)
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes(
                    [NSAttributedString.Key.font: UIFont(name: "calibri", size: 10)!],
                    for: .normal
                )
            }
        }
    }
}
