//
//  MessageData.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/28/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit

class MessagesData: NSObject {

    let id: String
    let name: String
    
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
}
