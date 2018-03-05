//
//  CoinbaseVC.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/23/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import coinbase_official

class CoinbaseVC: UIViewController {
    
    var clientID = "f67977ea795aea61d532175fbb96964b193111ba89ec3e1ff95554b2ef588b04"
    var redirectURI = "com.Spencer.OurCoin.coinbase-oauth://coinbase-oauth"
  
    @IBOutlet weak var coinbaseButton: UIButton!
    
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinbaseButton.backgroundColor = .clear
        coinbaseButton.layer.cornerRadius = 5
        coinbaseButton.layer.borderWidth = 1
        coinbaseButton.layer.borderColor = UIColor.white.cgColor
        homeButton.backgroundColor = .clear
        homeButton.layer.cornerRadius = 5
        homeButton.layer.borderWidth = 1
        homeButton.layer.borderColor = UIColor.white.cgColor
        self.view.backgroundColor = UIColor.black

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.performSegue(withIdentifier: "homeScreen", sender: self)
    }
    
    @IBAction func handleCoinbaseAuth(_ sender: Any) {
        CoinbaseOAuth.startAuthentication(withClientId: clientID, scope: "user balance wallet:buys:create wallet:sells:create wallet:accounts:read", redirectUri: redirectURI, meta: nil)
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
