//
//  FirebaseManager.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 18/05/2024.
//

import Foundation
import Firebase
import FirebaseCore
import MessageKit

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
    
    func sendMessage(orderId: String, receiverId: Int, message: String, type: String) {
        let ref = Database.database().reference()
        let messageData: [String: Any] = [
            "senderId": UserInfo.shared.get_ID(),
            "sender": "captain",
            "receiverId": receiverId,
            "message": message,
            "type": type,
            "createdAt": DateFormatter.dateFormatter.string(from: Date())
        ]

        ref.child("Chatting").child(orderId).childByAutoId().setValue(messageData)
    }
    
//    func sendMessage(orderId: String, receiverId: Int, message: String, type: String) {
//        let ref = Database.database().reference()
//        let messageData: [String: Any] = [
//            "senderId": 230,
//            "sender": "customer",
//            "receiverId": 1,
//            "message": message,
//            "type": type,
//            "createdAt": DateFormatter.dateFormatter.string(from: Date())
//        ]
//
//        ref.child("Chatting").child(orderId).childByAutoId().setValue(messageData)
//    }
    
    func fetchAllMessages(orderID: String, completion: @escaping ([Message]?) -> Void) {
        let ref = Database.database().reference()
        ref.child("Chatting").child(orderID).getData { error, snapshot in
            var messages: [Message] = []
            if let error = error {
                print("Error fetching initial messages: \(error)")
                completion(messages)
                return
            }
            
            guard let children = snapshot?.children.allObjects as? [DataSnapshot] else {
                completion(messages)
                return
            }
            
            for child in children {
                if let data = child.value as? [String: Any],
                   let senderId = data["senderId"] as? Int,
                   let senderName = data["sender"] as? String,
                   let messageText = data["message"] as? String,
                   let messageType = data["type"] as? String,
                   let createdAt = data["createdAt"] as? String {
                    let date = DateFormatter.dateFormatter.date(from: createdAt)
                    let sender = Sender(senderId: String(senderId), displayName: senderName)
                    let message = Message(sender: sender, messageId: child.key, sentDate: date ?? Date(), kind: .text(messageText))
                    messages.append(message)
                }
            }
            completion(messages)
        }
    }
    
    func observeNewMessage(orderID: String, completion: @escaping (Message?, String?) -> Void) {
        let ref = Database.database().reference()
        ref.child("Chatting").child(orderID).observe(.childAdded) { snapshot in
            print("Snapshot received: \(snapshot)")
            
            guard let data = snapshot.value as? [String: Any] else {
                print("Failed to cast snapshot value to [String: Any]")
                return
            }
            
            guard let senderId = data["senderId"] as? Int,
                  let senderName = data["sender"] as? String,
                  let messageText = data["message"] as? String,
                  let messageType = data["type"] as? String,
                  let createdAt = data["createdAt"] as? String else {
                print("Failed to parse message data")
                return
            }
            
            print("Message data parsed successfully")
            
            if senderName == "customer" {
                let date = DateFormatter.dateFormatter.date(from: createdAt)
                let sender = Sender(senderId: String(senderId), displayName: senderName)
                let message = Message(sender: sender, messageId: snapshot.key, sentDate: date ?? Date(), kind: .text(messageText))
                print("Message from customer: \(messageText)")
                completion(message, messageType)
            } else {
                print("Message is not from customer")
            }
        }
    }

    
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
