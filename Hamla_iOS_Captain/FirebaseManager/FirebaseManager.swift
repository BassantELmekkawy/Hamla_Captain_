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
import UIKit

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private var observerHandles: [String: DatabaseHandle] = [:]
    private var references: [String: DatabaseReference] = [:]
    
    
    func observeNewOrdersAddedToCaptain(captainId: String, completion: @escaping ([Int]?) -> Void) {
        let ref = Database.database().reference().child("OnlineCaptains").child(captainId)
        let ref2 = Database.database().reference().child("OnlineCaptains").child(captainId)
        ref.child("assignOrder").observe(.value, with: { snapshot in
            print("Raw snapshot value: \(snapshot.value ?? "nil")")
            
            ref2.child("currentOrder").observeSingleEvent(of: .value, with: { snapshot2 in
                
                print("Snapshot2 value: \(snapshot2.value ?? "nil")")
                
                guard let currentOrder = snapshot2.value as? Int else {
                    print("currentOrder is not found or invalid")
                    completion(nil)
                    return
                }
                
                if currentOrder != 0 {
                    print("currentOrder is not 0")
                    print("** \(currentOrder)")
                    completion(nil)
                    return
                }
                
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
            
        })
        //observerHandles[captainId] = handle
    }
    
    func observeCurrentOrder(captainId: String, completion: @escaping (Int?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("OnlineCaptains").child(captainId).child("currentOrder").observe(.value, with: { snapshot in
            print("Raw snapshot value: \(snapshot.value ?? "nil")")
            
            if let currentOrder = snapshot.value as? Int {
                print("Current Order: \(currentOrder)")
                completion(currentOrder)
            } else {
                print("Invalid Current Order")
                completion(nil)
            }
        })
    }
    
    func getCaptainStatus(captainId: String, completion: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("OnlineCaptains").child(captainId).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("Captain Online")
                completion(true)
            } else {
                print("Captain Offline")
                completion(false)
            }
        }
    }
    
    func getCaptainPriceForOrders(orderIDs: [Int], completion: @escaping ([Int: String]) -> Void) {
        let ref = Database.database().reference().child("tempOrders")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var ordersWithPrice: [Int: String] = [:]
            
            guard let ordersData = snapshot.value as? [String: [String: String]] else {
                completion(ordersWithPrice)
                return
            }
            
            let captainID = String(UserInfo.shared.get_ID())
            
            for orderID in orderIDs {
                if let captains = ordersData[String(orderID)], captains.keys.contains(captainID) {
                    let price = captains[captainID]
                    ordersWithPrice[orderID] = price
                }
            }
            
            completion(ordersWithPrice)
        }
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
    
    func sendMessage(orderID: String, receiverId: Int, message: String, type: String) {
        let ref = Database.database().reference()
        let messageRef = ref.child("chatting").child(orderID).child("messages").childByAutoId()
        let messageId = messageRef.key

        let messageData: [String: Any] = [
            "messageId": messageId ?? "",
            "senderId": UserInfo.shared.get_ID(),
            "sender": "captain",
            "receiverId": receiverId,
            "message": message,
            "type": type,
            "createdAt": Int(Date().timeIntervalSince1970 * 1000),
            "seen": false
        ]

        messageRef.setValue(messageData)
    }
    
//    func sendMessage(orderID: String, receiverId: Int, message: String, type: String) {
//        let ref = Database.database().reference()
//        let messageRef = ref.child("chatting").child(orderID).child("messages").childByAutoId()
//        let messageId = messageRef.key
//        let messageData: [String: Any] = [
//            "messageId": messageId ?? "",
//            "senderId": receiverId,
//            "sender": "customer",
//            "receiverId": UserInfo.shared.get_ID(),
//            "message": message,
//            "type": type,
//            "createdAt": Int(Date().timeIntervalSince1970 * 1000),
//            "seen": false
//        ]
//
//        messageRef.setValue(messageData)
//    }
    
    func fetchAllMessages(orderID: String, completion: @escaping ([Message]?) -> Void) {
        let ref = Database.database().reference()
        ref.child("chatting").child(orderID).child("messages").getData { error, snapshot in
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
            
            var kind: MessageKind?
            
            for child in children {
                if let data = child.value as? [String: Any],
                   let senderId = data["senderId"] as? Int,
                   let senderName = data["sender"] as? String,
                   let messageText = data["message"] as? String,
                   let messageType = data["type"] as? String,
                   let createdAt = data["createdAt"] as? Int,
                   let seen = data["seen"] as? Bool {
                    
                    switch messageType {
                    case "text":
                        kind = .text(messageText)
                    case "photo":
                        guard let imageUrl = URL(string: messageText),
                              let placeholder = UIImage(systemName: "photo") else { return }
                        let media = Media(url: imageUrl,
                                          placeholderImage: placeholder,
                                          size: CGSize(width: 300, height: 300))
                        kind = .photo(media)
                    default:
                        break
                    }
                    
                    guard let kind = kind else { return }
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(createdAt) / 1000)
                    let sender = Sender(senderId: String(senderId), displayName: senderName)
                    let message = Message(sender: sender, messageId: child.key, sentDate: date , kind: kind, seen: seen)
                    messages.append(message)
                }
            }
            completion(messages)
        }
    }
    
    func observeNewMessage(orderID: String, completion: @escaping (Message?) -> Void) {
        let ref = Database.database().reference()
        ref.child("chatting").child(orderID).child("messages").observe(.childAdded) { snapshot in
            print("Snapshot received: \(snapshot)")
            
            guard let data = snapshot.value as? [String: Any] else {
                print("Failed to cast snapshot value to [String: Any]")
                return
            }
            
            guard let senderId = data["senderId"] as? Int,
                  let senderName = data["sender"] as? String,
                  let messageText = data["message"] as? String,
                  let messageType = data["type"] as? String,
                  let createdAt = data["createdAt"] as? Int,
                  let seen = data["seen"] as? Bool else {
                print("Failed to parse message data")
                return
            }
            print("Message data parsed successfully")
            
            if senderName == "customer" {
                ref.child("Chatting").child(orderID).child(snapshot.key).updateChildValues(["seen": true]) { error, ref in
                    if let error = error {
                        print("Error updating seen: \(error)")
                    } else {
                        print("seen updated successfully")
                    }
                }
            }
            
            self.updateCaptainUnreadMessages(orderID: orderID)
            
            var kind: MessageKind?
            
            switch messageType {
            case "text":
                kind = .text(messageText)
            case "photo":
                guard let imageUrl = URL(string: messageText),
                      let placeholder = UIImage(systemName: "photo") else { return }
                let media = Media(url: imageUrl,
                                  placeholderImage: placeholder,
                                  size: CGSize(width: 300, height: 300))
                kind = .photo(media)
            default:
                break
            }
            
            guard let kind = kind else { return }
            
            let date = Date(timeIntervalSince1970: TimeInterval(createdAt) / 1000)
            let sender = Sender(senderId: String(senderId), displayName: senderName)
            let message = Message(sender: sender, messageId: snapshot.key, sentDate: date , kind: kind, seen: seen)
            completion(message)
        }
    }
    
    func observeMessageSeenStatus(orderID: String, completion: @escaping (Message?) -> Void) {
        let ref = Database.database().reference()
        ref.child("chatting").child(orderID).child("messages").observe(.childChanged) { snapshot in
            print("Snapshot received: \(snapshot)")
            
            guard let data = snapshot.value as? [String: Any] else {
                print("Failed to cast snapshot value to [String: Any]")
                return
            }
            
            guard let senderId = data["senderId"] as? Int,
                  let senderName = data["sender"] as? String,
                  let messageText = data["message"] as? String,
                  let messageType = data["type"] as? String,
                  let createdAt = data["createdAt"] as? Int,
                  let seen = data["seen"] as? Bool else {
                print("Failed to parse message data")
                return
            }
            print("Message data parsed successfully")
            
            var kind: MessageKind?
            
            switch messageType {
            case "text":
                kind = .text(messageText)
            case "photo":
                guard let imageUrl = URL(string: messageText),
                      let placeholder = UIImage(systemName: "photo") else { return }
                let media = Media(url: imageUrl,
                                  placeholderImage: placeholder,
                                  size: CGSize(width: 300, height: 300))
                kind = .photo(media)
            default:
                break
            }
            
            guard let kind = kind else { return }
            
            if senderName == "captain" {
                let date = Date(timeIntervalSince1970: TimeInterval(createdAt) / 1000)
                let sender = Sender(senderId: String(senderId), displayName: senderName)
                let message = Message(sender: sender, messageId: snapshot.key, sentDate: date , kind: kind, seen: seen)
                completion(message)
            }
        }
    }
    
    func observeCustomerTyping(orderID: String, completion: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference()
        ref.child("chatting").child(orderID).child("chatStatus").child("customerTyping").observe(.value) { snapshot in
            if let customerTyping = snapshot.value as? Bool {
                completion(customerTyping)
            }
        }
    }
    
    func observeCaptainUnreadMessages(orderID: String, completion: @escaping (Int?) -> Void) {
        let ref = Database.database().reference()
        ref.child("chatting").child(orderID).child("chatStatus").child("captainUnreadMsg").observe(.value) { snapshot in
            if let captainUnreadMessages = snapshot.value as? Int {
                completion(captainUnreadMessages)
            }
        }
    }
    
    private func updateCaptainUnreadMessages(orderID: String) {
        let ref = Database.database().reference()
        ref.child("chatting").child(orderID).child("chatStatus").child("captainUnreadMsg").setValue(0) { error, _ in
            if let error = error {
                print("Error updating captainTyping: \(error.localizedDescription)")
            }
        }
    }
    
    func updateCaptainTyping(orderID: String, isTyping: Bool) {
        let ref = Database.database().reference()
        ref.child("chatting").child(orderID).child("chatStatus").child("captainTyping").setValue(isTyping) { error, _ in
            if let error = error {
                print("Error updating captainTyping: \(error.localizedDescription)")
            }
        }
    }
    
    // increments customer unread messages by 1
    func updateCustomerUnreadMessages(orderID: String) {
        let ref = Database.database().reference()
        let customerUnreadMsgRef = ref.child("chatting").child(orderID).child("chatStatus").child("customerUnreadMsg")
        
        customerUnreadMsgRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if let unreadCount = currentData.value as? Int {
                currentData.value = unreadCount + 1
            } else {
                currentData.value = 1
            }
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, snapshot in
            if let error = error {
                print("Error incrementing customerUnreadMsg: \(error.localizedDescription)")
            } else if !committed {
                print("Transaction not committed")
            } else {
                if let value = snapshot?.value as? Int {
                    print("Successfully incremented customerUnreadMsg to \(value)")
                }
            }
        }
    }


}
