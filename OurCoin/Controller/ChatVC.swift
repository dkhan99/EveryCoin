//
//  ChatVC.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/29/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

final class ChatVC: MessagesViewController{
    
    private lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    
    var senderDisplayName: String?
    var senderId : String?
    var channelRef: DatabaseReference?
    var newSender: Sender?
    var channel: MessagesData?{
    
        didSet{
            title = channel?.name
        }
    }
    
    var messages: [Messages] = []{
        didSet{
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //conforming to three protocols of MessageKit
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        //get user email(name) and id from firebase
        self.senderDisplayName = Auth.auth().currentUser?.email
        self.senderId = Auth.auth().currentUser?.uid
        // Do any additional setup after loading the view.
        observeMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func observeMessages(){
        messageRef = channelRef!.child("messages")
        let messageQuery = messageRef.queryLimited(toLast: 25)
        
        newMessageRefHandle = messageQuery.observe(.childAdded, with:{(snapshot) -> Void in
            if let dictionary = snapshot.value as? NSDictionary {
                
                if let username = dictionary["senderName"] as? String, let id = dictionary["senderId"] as? String, let text = dictionary["text"] as? String{
                    self.newSender = Sender(id: id, displayName: username)
                    let messageDate = Date(timeIntervalSince1970: 1000)
                    self.addMessage(text: text, sender: self.newSender!, withId: id, date: messageDate)
//                    print("My message is \(text)")
//                    print("My id is \(id)")
//                    print("My username is \(username)")
//                    print("Number of messages: \(self.messages.count)")
//                    print("Senrder is \(self.newSender)")
                }else{
                    print("ERROR, COULD NOT FETCH DATA")
                }
            }
        })
        
    }
    
    private func addMessage(text:String, sender:Sender, withId id: String, date:Date){
        
        let message = Messages(text: text, sender: sender, messageId: id, date: date)
        
        self.messages.append(message)
        
    }
    
    
}
extension ChatVC: MessagesDataSource{
    
    func currentSender() -> Sender {
        return self.newSender!
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
}

extension ChatVC: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }


}

extension ChatVC: MessageInputBarDelegate{

    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let itemRef = messageRef.childByAutoId()

        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text
        ]
        
        itemRef.setValue(messageItem)
        //itemRef.setValue(ServerValue.timestamp())
        messageInputBar.inputTextView.text = ""
        messagesCollectionView.scrollToBottom()

    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


