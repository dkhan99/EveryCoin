//
//  ViewController.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/23/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import LinkKit
import SwiftyJSON
import Alamofire
import coinbase_official
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var coinbaseButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    var accessToken: String = ""
    var transactions: String = ""
    var transactItem: [UserTransactionData] = []
    var transactionRef: DatabaseReference?
    var clientID = "f67977ea795aea61d532175fbb96964b193111ba89ec3e1ff95554b2ef588b04"
    var redirectURI = "com.Spencer.OurCoin.coinbase-oauth://coinbase-oauth"
    
    //create firebase reference for transactions
    let ref = Database.database().reference(withPath: "Transaction_Data")
    
//    var transRef: DatabaseReference?
//    private lazy var transactionsRef: DatabaseReference = self.transRef!.child("transactions")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveNotification(_:)), name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //PLAID Button
        button.isEnabled = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        //COINBASE Button
        coinbaseButton.backgroundColor = .clear
        coinbaseButton.layer.cornerRadius = 5
        coinbaseButton.layer.borderWidth = 1
        coinbaseButton.layer.borderColor = UIColor.white.cgColor
        //HOME BUTTON
        homeButton.backgroundColor = .clear
        homeButton.layer.cornerRadius = 5
        homeButton.layer.borderWidth = 1
        homeButton.layer.borderColor = UIColor.white.cgColor
        self.view.backgroundColor = UIColor.black
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func handleCoinbaseAuth(_ sender: Any) {
        CoinbaseOAuth.startAuthentication(withClientId: clientID, scope: "user balance wallet:buys:create wallet:sells:create wallet:accounts:read", redirectUri: redirectURI, meta: nil)
    }
    
    @objc func didReceiveNotification(_ notification: NSNotification) {
        if notification.name.rawValue == "PLDPlaidLinkSetupFinished" {
            NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
            button.isEnabled = true
        }
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {


        print("loginButton didCompleteWith \(error)")

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        self.performSegue(withIdentifier: "loginSegue", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPlaidButton(_ sender: Any) {
        presentPlaidLinkWithCustomConfiguration()
        
    }
    
    @IBAction func didTapGoOnButton(_ sender: Any) {
        self.performSegue(withIdentifier: "homeScreen", sender: self)
    }
    
    func handleSuccessWithToken(_ publicToken: String, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata ?? [:])")
        
        
    }
    
    func handleError(_ error: Error, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Failure", message: "error: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
        
    }
    
    func handleExitWithMetadata(_ metadata: [String : Any]?) {
        presentAlertViewWithTitle("Exit", message: "metadata: \(metadata ?? [:])")
    }
    
    func presentAlertViewWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Plaid Link setup with custom configuration
    func presentPlaidLinkWithCustomConfiguration() {
        // With custom configuration
        //NEED TO CHANGE FROM SANDBOX TO DEVELOPMENT WHEN READY TO TEST
        let linkConfiguration = PLKConfiguration(key: "8ea673842707bcd8f600508a10e315", env: .sandbox, product: [.auth,.transactions])
        linkConfiguration.clientName = "Link Demo"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
    }
    
    func getAccessUsingAlamofire(_ publicToken: String){
        
        //creates parameters to get access token from client id, secret and public token
        let parameters: Parameters = ["client_id": "5a1671594e95b865a853b9f4",
                                        "secret": "9fe0455f014d0070b2c5261afc8795",
                                        "public_token": publicToken
                                        ]
        //makes http request using alamofire
        Alamofire.request("https://sandbox.plaid.com/item/public_token/exchange", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{(DataResponse) -> Void in
            if((DataResponse.result.value) != nil) {
                //paring JSON data to get access token from Plaid exchange flow http request
                let swiftyJsonVar = JSON(DataResponse.result.value!)
                let accessToken = swiftyJsonVar["access_token"].stringValue
                self.getTransactData(accessToken)
                print("Use this token: \(accessToken)")
            }
        }
        
    }
    
    func getTransactData(_ accessToken: String){
        //sets parameters to get transact data
        let paramters2 : Parameters = ["client_id": "5a1671594e95b865a853b9f4",
                                       "secret": "9fe0455f014d0070b2c5261afc8795",
                                       "access_token": accessToken,
                                       "start_date": "2017-01-01",
                                       "end_date": "2017-12-06",
                                       ]
        
        Alamofire.request("https://sandbox.plaid.com/transactions/get", method: .post, parameters: paramters2, encoding: JSONEncoding.default).responseJSON{(DataResponse) -> Void in
            if ((DataResponse.result.value) != nil) {
                let swiftyJSON = JSON(DataResponse.result.value!)
                //gets amount of each transactions
                let transact = swiftyJSON["transactions"].arrayValue.map({$0["amount"].intValue})
                //gets name of each transaction
                let name = swiftyJSON["transactions"].arrayValue.map({$0["name"].stringValue})
                //gets unique account id for each transaction
                let transactionId = swiftyJSON["transactions"].arrayValue.map({$0["account_id"].stringValue})
                //let category = swiftyJSON["transactions"].arrayValue.map({$0["category"].arrayValue})
                let totalTransactions = swiftyJSON["total_transactions"].intValue
                
                //create instance of transaction data
                for x in 0..<(totalTransactions){
                    self.transactItem.append(UserTransactionData(amount: transact[x], transactionName: name[x], transactionId: transactionId[x]))
                    print("Items: \(self.transactItem[x].amount ) \t \(self.transactItem[x].transactionName ) \t \(self.transactItem[x].transactionId)")
                    self.transactionRef = self.ref.child(self.transactItem[x].transactionId)
                    self.transactionRef?.setValue(self.transactItem[x].toAnyObject())
                }
                
            }
        }
    }
    
}

extension ViewController : PLKPlaidLinkViewDelegate
{
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
            self.handleSuccessWithToken(publicToken, metadata: metadata)
            self.getAccessUsingAlamofire(publicToken)
    }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
                self.handleError(error, metadata: metadata)
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
                self.handleExitWithMetadata(metadata)
            }
        }
    }
    

    
}
