//
//  UserTransactionData.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/23/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit

class UserTransactionData: NSObject {
    
    let amount: Int
    let transactionName: String
    let transactionId: String
    
    init(amount: Int, transactionName: String, transactionId: String){
        self.amount = amount
        self.transactionName = transactionName
        self.transactionId = transactionId
    }
    
    
    //Converts object to dictionary
    func toAnyObject() -> Any {
        return [
            "amount": amount,
            "transactionName": transactionName,
            "transactionId": transactionId
        ]
    }
    

}
