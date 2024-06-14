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
    
    
    func observeNewOrdersAddedToCaptain(captainId: String, completion: @escaping ([Int]?) -> Void) {
        let ref = Database.database().reference()
        
        let handle = ref.child("OnlineCaptains").child(captainId).child("assignOrder").observe(.value, with: { snapshot in
            print("Raw snapshot value: \(snapshot.value ?? "nil")")
            
            if let assignOrder = snapshot.value as? [Any] {
                print("assign Orders: \(assignOrder)")
                
                // Process captainData to filter out null values in arrays
                let filteredArray = assignOrder.compactMap { $0 as? Int }
                
                print("Filtered assign Orders: \(filteredArray)")
                completion(filteredArray)
            } else if let assignOrder = snapshot.value as? Int {
                print("Single assign Order: \(assignOrder)")
                completion([])
            } else {
                print("Invalid assign Orders")
                completion([])
            }
        })
        observerHandles[captainId] = handle
    }
    
    func updateLocation(captainId: String, lat: String, lng: String) {
        let ref = Database.database().reference()
        
        let location: [String: String] = ["lat": lat, "lng": lng]
        
        ref.child("OnlineCaptains").child(captainId).updateChildValues(location) { (error, ref) in
            if let error = error {
                print("Error updating location: \(error)")
            } else {
                print("Location updated successfully")
            }
        }
    }

    
//    func observeNewOrdersAddedToCaptain(captainId: String,completion: @escaping ([Any]?) -> Void) {
//        let ref = Database.database().reference()
//
//        let handle = ref.child("OnlineCaptains").child(captainId).child("assignOrder").observe(.value, with: { snapshot in
//        guard let assignOrder = snapshot.value as? [Any] else { return}
//                print("assign Orders: \(assignOrder)")
//
//                // Process captainData to filter out null values in arrays
//                let filteredArray = assignOrder.compactMap { $0 as? Int }
//
//
//                print("assign Orders: \(filteredArray)")
//                completion(filteredArray)
//                //completion(captainData)
//            }
//        )
//        observerHandles[captainId] = handle
//    }
    
    func removeObserverForCaptain(captainId: String) {
        if let handle = observerHandles[captainId], let ref = references[captainId] {
            ref.removeObserver(withHandle: handle)
            observerHandles.removeValue(forKey: captainId)
            references.removeValue(forKey: captainId)
        }
    }
}
