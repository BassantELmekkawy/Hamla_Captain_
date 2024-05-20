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
    
    func observeNewOrdersAddedToCaptain(captainId: String,completion: @escaping ([String: Any]?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("OnlineCaptains").child(captainId).observe(.value, with: { snapshot in
        guard let captainData = snapshot.value as? [String: Any] else { return}
                print("captain Data: \(captainData)")
                completion(captainData)
            }
        )
                                               
    }
}
