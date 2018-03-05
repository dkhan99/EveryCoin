//
//  TransactionTableVC.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/26/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import Firebase

class TransactionTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var transRef: DatabaseReference?
    
    private lazy var transactionRef = Database.database().reference().child("Transaction_Data") 
        //DatabaseReference = self.transRef!.child("Transaction_Data")
    private var newTransactionHandle: DatabaseHandle?
    
    var amount: Int?
    var transactionName: String?
    var transactionId: String?
    var channelRef: DatabaseReference?
    @IBOutlet weak var transactionTableView: UITableView!
    
    var transactions: [UserTransactionData] = []{
        didSet{
            DispatchQueue.main.async {
                self.transactionTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transactionTableView.delegate = self
        self.transactionTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        observeMessages()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func returnTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);

    }
    
    private func observeMessages(){
        //transactionRef = channelRef!.child("Transaction_Data")
        
        transactionRef.observe(.childAdded, with:{(snapshot) -> Void in
            if let dictionary = snapshot.value as? NSDictionary {
                
                if let amount = dictionary["amount"] as? Int, let id = dictionary["transactionId"] as? String, let name = dictionary["transactionName"] as? String{
                    self.addTranasactions(amount: amount, transactionName: id, transactionId: name)
                    print("Amount is: \(amount)")
                    
                }else{
                    
                }
            }
        })
        
    }
 
    private func addTranasactions(amount:Int, transactionName:String, transactionId:String){
        
        let transact = UserTransactionData(amount: amount, transactionName: transactionName, transactionId: transactionId)

        self.transactions.append(transact)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "transactionCell"
        
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let tData = transactions[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = String(tData.amount)
        cell.detailTextLabel?.text = tData.transactionId
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
           // transactionTableView.deleteRows(at: [indexPath], with: .fade)
            //transactionRef.observe(.childRemoved, with: { (snapshot) -> Void in
                //et index = self.transactions[indexPath.row]
                //let state = id[indexPath.row]
            
                
           // })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func deleteMessageAtIndex(mIndex:Int) {
        let row : IndexPath = IndexPath(row: mIndex, section:0)
        transactions.remove(at: mIndex)
        transactionTableView.deleteRows(at: [row], with: UITableViewRowAnimation.fade)
        transactionTableView.reloadData()
    }
    
    

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
