//
//  FirebaseManager.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 18/05/2024.
//

import Foundation
import Firebase
import FirebaseCore

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private var observerHandles: [String: DatabaseHandle] = [:]
    private var references: [String: DatabaseReference] = [:]
    
    func observeNewOrdersAddedToCaptain(captainId: String,completion: @escaping ([String: Any]?) -> Void) {
        let ref = Database.database().reference()
        
        let handle = ref.child("OnlineCaptains").child(captainId).observe(.value, with: { snapshot in
        guard let captainData = snapshot.value as? [String: Any] else { return}
                print("captain Data: \(captainData)")
                completion(captainData)
            }
        )
        observerHandles[captainId] = handle
    }
    
    func removeObserverForCaptain(captainId: String) {
        if let handle = observerHandles[captainId], let ref = references[captainId] {
            ref.removeObserver(withHandle: handle)
            observerHandles.removeValue(forKey: captainId)
            references.removeValue(forKey: captainId)
        }
    }
}
