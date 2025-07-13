//
//  CodeViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-10.
//

import UIKit
import Firebase

class CodeViewController: BaseAuthenticationViewController {
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    let firebaseManager = FirebaseManager()
    let alertManager = AlertManager()
    let db = Firestore.firestore().collection("users")
    
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
    
    
    
    @IBAction func enterPressed(_ sender: UIButton) {
        if let code = codeTextField.text {
            firebaseManager.confirmCoach(code: code) { result in
                if let result = result {
                    self.db.document(Auth.auth().currentUser!.uid).setData(["coachId": code, "coachName": result], merge: true)
                    self.performSegue(withIdentifier: K.codeTabSegue, sender: self)
                } else {
                    self.alertManager.showAlert(alertMessage: "We could not find a coach with this code. Please try again.", viewController: self)
                }
            }
        } else {
            alertManager.showAlert(alertMessage: "Please enter a code.", viewController: self)
        }
    }
}
