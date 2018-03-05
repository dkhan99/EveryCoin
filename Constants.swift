//
//  Constants.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/26/17.
//  Copyright © 2017 USC. All rights reserved.
//

import Foundation
import Firebase


//The code below is a nested struct, a structure to store variables in.
//Whenever i now need access to the reference for chat data, you can use:
    //Constants.refs.databaseChats

struct Constants{
    struct refs{
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
