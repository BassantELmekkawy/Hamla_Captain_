//
//  ChatVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 14/06/2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    let sender: SenderType
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
}

struct Sender: SenderType {
    let senderId: String
    let displayName: String
}

class ChatVC: MessagesViewController {
    
    var messages: [MessageType] = []
    
    let captain = Sender(senderId: "1", displayName: "captain")
    let customer = Sender(senderId: "2", displayName: "customer")

    override func viewDidLoad() {
        super.viewDidLoad()
                
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        fetchMessages(orderID: "20")
        observeNewMessage(orderID: "20")
        //messagesCollectionView.reloadData()
    }
    
    func fetchMessages(orderID: String) {
        FirebaseManager.shared.fetchAllMessages(orderID: orderID) { messages in
            guard let messages = messages else {
                return
            }
            self.messages = messages
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    
    func observeNewMessage(orderID: String) {
        FirebaseManager.shared.observeNewMessage(orderID: orderID) { message, type in
            guard let message = message, let type = type else {
                return
            }
            if type == "text" {
                self.messages.append(message)
                //self.messagesCollectionView.reloadDataAndKeepOffset()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
}

extension ChatVC: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        captain
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
}

extension ChatVC: MessagesLayoutDelegate, MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == "1" {
            return UIColor(named: "primary") ?? .blue
        }
        return .darkGray
    }
}

extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = Message(sender: currentSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        messages.append(newMessage)
        messagesCollectionView.reloadData()
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToLastItem()
        FirebaseManager.shared.sendMessage(orderId: "20", receiverId: 230, message: text, type: "text")
        //FirebaseManager.shared.sendMessage(orderId: "20", receiverId: UserInfo.shared.get_ID(), message: text, type: "text")
    }
}
