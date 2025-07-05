//
//  FirebaseManager.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import Firebase

struct FirebaseManager {
    let db = Firestore.firestore()
        
    func createUserDocument(firstName: String, lastName: String, role: String, email: String, uid: String) {
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "role": "athlete",
            "coachId": "",     // blank for now; set later
            "createdAt": Timestamp()
        ]

        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error writing user document: \(error)")
            } else {
                print("User document successfully created!")
            }
        }
    }
}
