//
//  APIManager.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 12/5/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit

class APIManager: ManagerBase {
    
    func convertDictionaryToJsonData(_ inputDict : Dictionary<String, Any>) -> Data?{
        
        do{
            return try JSONSerialization.data(withJSONObject: inputDict, options:JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error as NSError{
            print(error)
            
        }
        
        return nil
    }
    
    func convertJsonDataToDictionary(_ inputData : Data) -> Array<[String:AnyObject]>? {
        guard inputData.count > 1 else{ return nil }
        
        do {
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }catch let error as NSError{
            print(error)
            
        }
        return nil
    }
}
