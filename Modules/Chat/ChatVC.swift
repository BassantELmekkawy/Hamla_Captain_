//
//  ChatVC.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 14/06/2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Kingfisher

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

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}

class ChatVC: MessagesViewController {
    
    let pickerVC = PhotoActionSheet()
    var viewModel: ChatViewModel?
    var orderID = 0
    var receiverID = 0
    var customerName = ""
    var messages: [MessageType] = []
    
    let captain = Sender(senderId: String(UserInfo.shared.get_ID()),
                         displayName: "captain")
    //let customer = Sender(senderId: "2", displayName: "customer")
    
    let leftBarButtonView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel(frame: CGRect(x: 0, y: 5, width: 200, height: 20))
        title.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        title.textColor = UIColor(named: "primary-dark")
        return title
    }()
    
    let subTitleLabel: UILabel = {
        let title = UILabel(frame: CGRect(x: 0, y: 25, width: 100, height: 16))
        title.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        title.textColor = UIColor(named: "forest")
        return title
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
               
        self.setupNavigationBar()
        configureCustomTitle()
        //navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrowshape.backward")
        //navigationItem.leftBarButtonItem?.image = UIImage(systemName: "arrowshape.backward")
        
        viewModel = ChatViewModel()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        setupInputBar()
        fetchMessages(orderID: String(orderID))
        observeNewMessage(orderID: String(orderID))
        pickerVC.delegate = self
        bindData()
    }
    
    private func configureCustomTitle() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back_button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonDidPressed))]
        titleLabel.text = customerName
        subTitleLabel.text = "Active"
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subTitleLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
    }
    
    @objc func backButtonDidPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func bindData(){
        viewModel?.uploadImageResult.bind { [self] result in
            guard let message = result?.message, let data = result?.data else { return }
            let dashboardStorageUrl = "http://hamla.selfip.net:8080/hamla-development/dashboard/public/storage/"
            if result?.status == 0 {
                self.showAlert(message: message)
            }
            else {
                let kind: MessageKind?
                guard let imageUrl = URL(string: dashboardStorageUrl + data),
                      let placeholder = UIImage(systemName: "photo") else { return }
                let media = Media(url: imageUrl,
                                  placeholderImage: placeholder,
                                  size: CGSize(width: 300, height: 300))
                kind = .photo(media)
                guard let kind = kind else { return }
                let newMessage = Message(sender: currentSender, messageId: UUID().uuidString, sentDate: Date(), kind: kind)
                messages.append(newMessage)
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToLastItem()
                FirebaseManager.shared.sendMessage(orderId: String(orderID), receiverId: receiverID, message: dashboardStorageUrl + data, type: "photo")
            }
            
            print(message)
        }
        
        viewModel?.errorMessage.bind{ error in
            if let error = error {
                self.showAlert(message: error)
                print(error)
            }
        }
    }
    
    private func setupInputBar() {
//        let button = InputBarButtonItem()
//        button.setSize(CGSize(width: 35, height: 35), animated: false)
//        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
//        button.tintColor = .gray
//        button.onTouchUpInside { _ in
//            self.pickerVC.configureImagePicker(from: self)
//        }
//        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
//        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.setSize(CGSize(width: 56, height: 56), animated: false)
        messageInputBar.sendButton.setImage(UIImage(named: "send_button"), for: .normal)
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.backgroundColor = UIColor(named: "primary")
        messageInputBar.sendButton.cornerRadius = 28
        
        messageInputBar.inputTextView.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        messageInputBar.inputTextView.textColor = UIColor(named: "gray1")
        messageInputBar.inputTextView.placeholder = "Write message..."
        messageInputBar.inputTextView.backgroundColor = UIColor(named: "background")

        let padding = (56 - messageInputBar.inputTextView.font.lineHeight) / 2
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: padding, left: 20, bottom: padding, right: 20)
        messageInputBar.inputTextView.layer.cornerRadius = 28
        messageInputBar.inputTextView.clipsToBounds = true
        messageInputBar.separatorLine.isHidden = true
        
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
        FirebaseManager.shared.observeNewMessage(orderID: orderID) { message in
            guard let message = message else {
                return
            }
            if message.kind.messageKindString == "text" {
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
        if message.sender.senderId == captain.senderId {
            return UIColor(named: "#F2F8FF") ?? .blue
        }
        return UIColor(named: "background") ?? .lightGray
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == captain.senderId {
            return UIColor(named: "primary") ?? .blue
        }
        return UIColor(named: "quaternary") ?? .lightGray
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.kf.setImage(with: imageUrl)
        default:
            break
        }
    }
    
}

extension ChatVC: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        let message = messages[indexPath.section]
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerVC(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        let newMessage = Message(sender: currentSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
//        messages.append(newMessage)
//        messagesCollectionView.reloadData()
//        inputBar.inputTextView.text = ""
//        messagesCollectionView.scrollToLastItem()
//        FirebaseManager.shared.sendMessage(orderId: String(orderID), receiverId: receiverID, message: text, type: "text")
//        //FirebaseManager.shared.sendMessage(orderId: "20", receiverId: UserInfo.shared.get_ID(), message: text, type: "text")
        print("send")
        print(messageInputBar.rightStackView.frame.height)
        print(messageInputBar.inputTextView.font.lineHeight)
        print(messageInputBar.inputTextView.font)
        print(messageInputBar.sendButton.frame.height)
        print(messageInputBar.inputTextView.frame.height)
    }
}

extension ChatVC: PhotoActionSheetDelegate {
    
    func didSelectImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        viewModel?.uploadImageToserver(file: imageData)
    }
}
