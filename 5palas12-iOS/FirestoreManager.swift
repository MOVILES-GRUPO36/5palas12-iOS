//
//  FirestoreManager.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 13/10/24.
//

import FirebaseFirestore

class FirestoreManager {
    
    static let shared = FirestoreManager()

    let db: Firestore

    private init() {
        db = Firestore.firestore()
    }

    func addData(collection: String, document: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection(collection).document(document).setData(data) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
            completion(error)
        }
    }

    func getData(collection: String, document: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        let docRef = db.collection(collection).document(document)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document data: \(document.data() ?? [:])")
            } else {
                print("Document does not exist")
            }
            completion(document, error)
        }
    }
}
