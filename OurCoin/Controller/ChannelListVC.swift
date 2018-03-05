//
//  ChannelListVC.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 12/2/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import Firebase

enum Section: Int{
    case createNewChannelSection = 0
    case currentChannelsSection
}

class ChannelListVC: UITableViewController {

    var senderDisplayName: String?
    var newChannelTextField: UITextField?
    private var channels: [MessagesData] = []
    
    private lazy var  channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var channelRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crypto Channels"
        observeChannels()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    deinit{
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    @IBAction func createChannel(_ sender: Any) {
        if let name = newChannelTextField?.text{
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = [
                "name": name
            ]
            newChannelRef.setValue(channelItem)
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section){
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels.count
            }
        }
        else{
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if  (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue{
            if let createNewChannelCell = cell as? CreateChannelCell{
                newChannelTextField = createNewChannelCell.newChannelNameField
            }
            
        }else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue{
            cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
        }
        return cell
    }
 
    private func observeChannels(){
        //listening for new channesls that are added to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: {(snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.count > 0 {
                self.channels.append(MessagesData(id:id, name:name))
                DispatchQueue.main.async {
                self.tableView.reloadData()
                }
            }else{
                print ("Error. Could not fetch table data")
            }
            
        })
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == Section.currentChannelsSection.rawValue){
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? MessagesData{
            let chatVC = segue.destination as! ChatVC
            
            chatVC.senderDisplayName = senderDisplayName
            chatVC.channel = channel
            chatVC.channelRef = channelRef.child(channel.id)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMessageAtIndex(mIndex: indexPath.row)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func deleteMessageAtIndex(mIndex:Int) {
        let row : IndexPath = IndexPath(row: mIndex, section:1)
        self.channels.remove(at: mIndex)
        self.tableView.deleteRows(at: [row], with: UITableViewRowAnimation.fade)
        self.tableView.reloadData()
    }
 

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
