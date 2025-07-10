//
//  FirebaseManager.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import Firebase


struct FirebaseManager {
    let db = Firestore.firestore()
    let alertManager = AlertManager()
    
    func createUserDocument(firstName: String, lastName: String, role: String, coachId: String?, email: String, uid: String) {
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "role": role,
            "coachId": coachId ?? "",
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
    
    func getUserData(uid: String, value: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                if let data = document?.data() {
                    let role = data[value] as? String
                    completion(role)
                } else {
                    completion("Role does not exist")
                }
            }
        }
    }
    
    func generateUniqueCoachId(completion: @escaping (String?) -> Void) {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let coachId = String((0..<6).map { _ in characters.randomElement()! })
        
        db.collection("users").whereField("coachId", isEqualTo: coachId).getDocuments { snapshot, error in
            if let error = error {
                completion(nil) // or completion(error.localizedDescription) if you want to return the error string
            } else if snapshot?.isEmpty == true {
                completion(coachId)
            } else {
                // Try again if not unique
                generateUniqueCoachId(completion: completion)
            }
        }
    }
    
    //func athleteSearchedCode
}
