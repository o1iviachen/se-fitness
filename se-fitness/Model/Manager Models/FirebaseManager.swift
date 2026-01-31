//
//  FirebaseManager.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import Firebase

// MARK: - FirebaseError

enum FirebaseError: Error {
    case documentNotFound
    case fieldNotFound(String)
    case networkError(Error)
    case unknown
}

// MARK: - FirebaseManager

final class FirebaseManager {

    // MARK: - Properties

    static let shared = FirebaseManager()
    private let db = Firestore.firestore()

    // MARK: - Initialization

    private init() {}
    
    // MARK: - Public Methods

    func fetchUserDocument(uid: String, completion: @escaping (DocumentSnapshot?) -> Void) {
        /**
         Fetches a Firebase Firestore document authorized through the user's email.

         - Parameters:
            - completion (Optional DocumentSnapshot): Stores the Firebase Firestore information at the time of the call.
         */

        db.collection("users").document(uid).getDocument { document, error in

            // If an error occurs in fetching document, call completion handler with no document snapshot (nil); code from https://cloud.google.com/firestore/docs/manage-data/add-data
            guard let document = document else {
                completion(document)
                return
            }

            // If the document is empty, call completion handler with no document snapshot (nil)
            guard document.data() != nil else {
                completion(document)
                return
            }

            completion(document)
        }
    }
    
    func createUserDocument(firstName: String, lastName: String, role: String, coachId: String?, email: String, uid: String) {
        var userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "role": role,
            "coachId": coachId ?? "",
            "workoutsCompleted": 0,
            "createdAt": Timestamp()
        ]
        
        if role == "coach" {
            userData["athletes"] = [:]
        }
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error writing user document: \(error)")
            } 
        }
    }
    
    
    
    func getUserData(uid: String, value: String, completion: @escaping (Any?) -> Void) {
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
        let coachId = String((0..<6).compactMap { _ in characters.randomElement() })

        db.collection("users").whereField("coachId", isEqualTo: coachId).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                completion(error.localizedDescription)
            } else if snapshot?.isEmpty == true {
                completion(coachId)
            } else {
                // Try again if not unique
                self.generateUniqueCoachId(completion: completion)
            }
        }
    }
    
    func confirmCoach(code: String, completion: @escaping (String?) -> Void) {
        db.collection("users").whereField("coachId", isEqualTo: code).whereField("role", isEqualTo: "coach").getDocuments { snapshot, error in
            if let error = error {
                completion(error.localizedDescription)
            } else if let doc = snapshot?.documents.first {
                let coachFirstName = doc.get("firstName") as? String ?? ""
                let coachLastName = doc.get("lastName") as? String  ?? ""
                completion("\(coachFirstName) \(coachLastName)")
            } else {
                completion(nil)
            }
        }
    }
    
    func addAthlete(athleteUid: String, code: String, completion: @escaping (String?) -> Void) {
        db.collection("users").whereField("coachId", isEqualTo: code).whereField("role", isEqualTo: "coach").getDocuments { snapshot, error in
            if let error = error {
                completion(error.localizedDescription)
            } else if let doc = snapshot?.documents.first {
                let athleteData: [String: Any] = ["workouts": [], "documents": []]
                doc.reference.updateData(["athletes.\(athleteUid)": athleteData]) { error in
                    if let error = error {
                        completion("Error writing to user document: \(error)")
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion("Coach not found")
            }
        }
    }

    // MARK: - Messages

    func sendMessage(athleteId: String, message: Message, completion: @escaping (Error?) -> Void) {
        /**
         Sends a message to the athlete's messages subcollection.

         - Parameters:
            - athleteId: The UID of the athlete (messages are stored under their document).
            - message: The Message object to send.
            - completion: Called with nil on success or an Error on failure.
         */
        db.collection("users").document(athleteId).collection("messages").addDocument(data: message.dictionary) { error in
            completion(error)
        }
    }

    func listenToMessages(athleteId: String, completion: @escaping ([Message]) -> Void) -> ListenerRegistration {
        /**
         Listens for real-time updates to an athlete's messages subcollection.

         - Parameters:
            - athleteId: The UID of the athlete whose messages to listen to.
            - completion: Called with an array of Messages whenever data changes.
         - Returns: A ListenerRegistration that can be used to remove the listener.
         */
        return db.collection("users").document(athleteId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                let messages = documents.compactMap { Message(document: $0) }
                completion(messages)
            }
    }

    func markMessageAsRead(athleteId: String, messageId: String) {
        /**
         Marks a message as read.

         - Parameters:
            - athleteId: The UID of the athlete.
            - messageId: The document ID of the message to mark as read.
         */
        db.collection("users").document(athleteId).collection("messages").document(messageId).updateData(["read": true])
    }

    func updateLastMessage(athleteId: String, message: String, timestamp: Date) {
        /**
         Updates the lastMessage fields on the athlete's user document for inbox previews.

         - Parameters:
            - athleteId: The UID of the athlete.
            - message: The message text preview.
            - timestamp: When the message was sent.
         */
        db.collection("users").document(athleteId).updateData([
            "lastMessage": message,
            "lastMessageTimestamp": Timestamp(date: timestamp)
        ])
    }

    // MARK: - Athletes

    func getAthletes(coachId: String, completion: @escaping ([User]) -> Void) {
        /**
         Fetches all athletes linked to a coach.

         - Parameters:
            - coachId: The UID of the coach.
            - completion: Called with an array of User objects representing athletes.
         */
        db.collection("users").document(coachId).getDocument { [weak self] document, error in
            guard let self = self, let document = document, let data = document.data(),
                  let athletes = data["athletes"] as? [String: Any] else {
                completion([])
                return
            }

            let athleteIds = Array(athletes.keys)
            var users: [User] = []
            let group = DispatchGroup()

            for athleteId in athleteIds {
                group.enter()
                self.db.collection("users").document(athleteId).getDocument { snapshot, error in
                    defer { group.leave() }
                    guard let snapshot = snapshot, let athleteData = snapshot.data() else { return }

                    let user = User(
                        uid: athleteId,
                        firstName: athleteData["firstName"] as? String ?? "",
                        lastName: athleteData["lastName"] as? String ?? "",
                        lastWorkoutDate: nil,
                        nextWorkoutDate: nil,
                        lastMessage: athleteData["lastMessage"] as? String
                    )
                    users.append(user)
                }
            }

            group.notify(queue: .main) {
                completion(users)
            }
        }
    }
}
