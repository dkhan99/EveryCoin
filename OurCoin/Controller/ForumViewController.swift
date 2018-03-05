//
//  ForumViewController.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/26/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

class ForumViewController : MessagesViewController{
//, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //conforms to three porotocols needs for messagekit to work
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
        
        backButton.titleLabel?.textColor = UIColor.white
        backButton.backgroundColor = .clear
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.white.cgColor
        self.view.backgroundColor = UIColor.black
    }
    
//    func currentSender() -> Sender {
//        <#code#>
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        <#code#>
//    }
//
//    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
//        <#code#>
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
