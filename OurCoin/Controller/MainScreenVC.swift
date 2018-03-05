//
//  MainScreenVC.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/25/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import SideMenu
import coinbase_official
import Alamofire
import SwiftyJSON

class MainScreenVC: UIViewController {

    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var ethLabel: UILabel!
    @IBOutlet weak var ltcLabel: UILabel!
    
    @IBOutlet weak var btcPriceLabel: UILabel!
    @IBOutlet weak var ethPriceLabel: UILabel!
    @IBOutlet weak var ltcPriceLabel: UILabel!
    
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.titleLabel?.textColor = UIColor.white
        menuButton.backgroundColor = .clear
        menuButton.layer.cornerRadius = 5
        menuButton.layer.borderWidth = 1
        menuButton.layer.borderColor = UIColor.white.cgColor
        
        btcLabel.textColor = UIColor.white
        ethLabel.textColor = UIColor.white
        ltcLabel.textColor = UIColor.white
        self.view.backgroundColor = UIColor.black
        
        let backgroundQ = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        backgroundQ.async{
            
            var backgroundTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
            backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = UIBackgroundTaskInvalid
            })
        self.getBTCPrice()
        self.getETHPrice()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //gets bitcoin price from coinbase api
    func getBTCPrice() -> Void{
        Coinbase().getSellPrice { (btc: CoinbaseBalance?, fees: [Any]?, subtotal: CoinbaseBalance?, total: CoinbaseBalance?, error: Error?) in
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.btcPriceLabel.text = "$\(total?.amount ?? "100")"
                self.btcPriceLabel.textColor = UIColor.white
            }
        }
    }
    
    //gets ether price and litecoin using Alamofire HTTP Networking
    func getETHPrice() -> Void{
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{(DataResponse) -> Void in
            var name : [String] = []
            if((DataResponse.result.value) != nil) {
                let swiftyJsonVar = JSON(DataResponse.result.value!)
                //loops through json and gets price of ether and litecoin
                for (first,subJson):(String, JSON) in swiftyJsonVar{
                    name.append(subJson["price_usd"].stringValue)
                    let price = subJson["name"].stringValue
                    print("NAME: \(price)")
                    //print("PRICE: \(name)")
                }
                
                self.ethPriceLabel.text = "$\(name[1])"
                self.ethPriceLabel.textColor = UIColor.white
                self.ltcPriceLabel.text = "$\(name[6])"
                self.ltcPriceLabel.textColor = UIColor.white

            }
    }
    }
    
    @IBAction func menuButton(_ sender: Any) {
        self.performSegue(withIdentifier: "sideMenu", sender: self)
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
