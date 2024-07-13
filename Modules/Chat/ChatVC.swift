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
    let seen: Bool
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
    var messages: [Message] = []
    var date: Date?
    
    let captain = Sender(senderId: String(UserInfo.shared.get_ID()),
                         displayName: "captain")
    //let customer = Sender(senderId: String(receiverID), displayName: "customer")
    
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
        title.textColor = UIColor(named: "primary")
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
        //fetchMessages(orderID: String(orderID))
        observeNewMessage(orderID: String(orderID))
        observeSeen(orderID: String(orderID))
        observeCustomerTyping(orderID: String(orderID))
        pickerVC.delegate = self
        bindData()
    }
    
    private func configureCustomTitle() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back_button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonDidPressed))]
        titleLabel.text = customerName
        subTitleLabel.text = ""
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
                let newMessage = Message(sender: currentSender, messageId: UUID().uuidString, sentDate: Date(), kind: kind, seen: false)
                messages.append(newMessage)
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToLastItem()
                FirebaseManager.shared.sendMessage(orderID: String(orderID), receiverId: receiverID, message: dashboardStorageUrl + data, type: "photo")
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
    
    func observeSeen(orderID: String) {
        FirebaseManager.shared.observeMessageSeenStatus(orderID: orderID) { message in
            guard let message = message else {
                return
            }
            if let index = self.messages.firstIndex(where: { $0.messageId == message.messageId }) {
                self.messages[index] = message
            }
            self.messagesCollectionView.reloadData()
        }
    }
    
    func observeCustomerTyping(orderID: String) {
        FirebaseManager.shared.observeCustomerTyping(orderID: orderID) { isTyping in
            guard let isTyping = isTyping else {
                return
            }
            self.subTitleLabel.text = isTyping ? "Typing..." : ""
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
        if isFromCurrentSender(message: message) {
            return UIColor(named: "#F2F8FF") ?? .blue
        }
        return UIColor(named: "background") ?? .lightGray
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
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
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section > 0, isSameDay(date1: message.sentDate, date2: messages[indexPath.section - 1].sentDate) {
            return nil
        }
        //let x = message.sentDate
        //let format = DateFormatter.dateFormatter.dateFormat = "E h:mm a"
        let dateString = message.sentDate.formattedString()
        return NSAttributedString(string: dateString, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor(named: "quaternary") ?? .gray])
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section > 0, isSameDay(date1: message.sentDate, date2: messages[indexPath.section - 1].sentDate) {
            return 0
        }
        return 40
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date2, inSameDayAs: date1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        var roundCorners: CACornerMask
        roundCorners = isFromCurrentSender(message: message) ? [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] : [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return .custom { container in
            container.roundCorners(roundCorners, radius: 18)
        }
    }
    
//    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        if isFromCurrentSender(message: message) {
//            let imageView = UIImageView(frame: CGRect(x: -20, y: 0, width: 20, height: 20))
//            imageView.image = UIImage(systemName: "checkmark.rectangle")
//            accessoryView.addSubview(imageView)
//        }
//
//    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message){
            //let text = "Seen"
            let attachment = NSTextAttachment()
            let seen = messages[indexPath.section].seen
            let icon = seen ? UIImage(named: "seen-checkmark") : UIImage(named: "seen-checkmark")?.withTintColor(.gray)
            attachment.image = icon
            let attachmentString = NSAttributedString(attachment: attachment)
            //let completeText = NSMutableAttributedString(string: text)
            //completeText.append(NSAttributedString(string: " "))
            //completeText.append(attachmentString)
            return attachmentString
        }
        return nil
    }
    
    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
        return LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        isFromCurrentSender(message: message) ? 20 : 0
    }
//    private func messageBottomLabelInsets(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 8)
//    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        .zero
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.displayName == currentSender.displayName
    }
}

extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = Message(sender: currentSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text), seen: false)
        //messages.append(newMessage)
        messagesCollectionView.reloadData()
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToLastItem()
        FirebaseManager.shared.sendMessage(orderID: String(orderID), receiverId: receiverID, message: text, type: "text")
        FirebaseManager.shared.updateCustomerUnreadMessages(orderID: String(orderID))
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text.isEmpty {
            FirebaseManager.shared.updateCaptainTyping(orderID: String(orderID), isTyping: false)
        } else {
            FirebaseManager.shared.updateCaptainTyping(orderID: String(orderID), isTyping: true)
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

extension ChatVC: PhotoActionSheetDelegate {
    
    func didSelectImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        viewModel?.uploadImageToserver(file: imageData)
    }
}
