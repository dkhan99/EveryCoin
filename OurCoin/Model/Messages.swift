//
//  Messages.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 12/3/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import MessageKit
import Foundation
import CoreLocation

struct Messages: MessageType {
 
    var data: MessageData
    var sender: Sender
    var messageId: String
    var sentDate: Date
    
    init(data: MessageData, sender: Sender, messageId: String, date: Date) {
        self.data = data
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(data: .text(text), sender: sender, messageId: messageId, date: date)
    }

}
