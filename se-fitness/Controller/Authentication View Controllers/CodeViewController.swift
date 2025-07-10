//
//  CodeViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-10.
//

import UIKit

class CodeViewController: BaseAuthenticationViewController {
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uiComponents: [UILabel] = [welcomeLabel, codeLabel]
        for uiComponent in uiComponents {
            uiComponent.font = UIFont(name: "calibri", size: 17)
        }
        codeTextField.font = UIFont(name: "calibri", size: 17)
        enterButton.titleLabel?.font = UIFont(name: "calibri", size: 17)
        enterButton.layer.cornerRadius = 12
    }
    
    
    @IBAction func searchCode(_ sender: Any) {
        
    }
}
