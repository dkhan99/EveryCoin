//
//  FBLoginVC.swift
//  OurCoin
//
//  Created by Spencer  Pearlman on 11/23/17.
//  Copyright © 2017 USC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftyJSON
import FBSDKLoginKit


class FBLoginVC: UIViewController, FBSDKLoginButtonDelegate{
    var loginButton : FBSDKLoginButton!
    var facebookName : String?
    
    @IBOutlet weak var didTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loginButton = FBSDKLoginButton()
//        loginButton.delegate = self
          self.view.backgroundColor = UIColor.black
          didTitleLabel.textColor = UIColor.white
//        loginButton.frame = CGRect(x: 15, y: 650, width: view.frame.width - 30, height: 30)
//        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        self.view.addSubview(loginButton)
        
        
        //CUSTOM FB BUTTON LOGIN
        let customFBButton = UIButton(type: .system)
        customFBButton.backgroundColor = .black
        customFBButton.frame = CGRect(x: 15, y: 650, width: view.frame.width - 30, height: 30)
        customFBButton.setTitle("Login with Google", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        customFBButton.setTitleColor(.white, for: .normal)
        customFBButton.layer.borderColor = UIColor.white.cgColor
        self.view.addSubview(customFBButton)
        
        customFBButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(FBSDKAccessToken.current() != nil){
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    @objc func handleLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_friends"] , from: self){
            (result, err) in
            
            if(FBSDKAccessToken.current() != nil){
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                }
            }
            
            if err != nil{
                print ("Custom FB Login Failed")
            }
            
//            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//            Auth.auth().signIn(with: credential) { (user, error) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//            }
            self.showEmailAddress()
            //print (result?.token.tokenString as Any)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if error != nil{
            print(error!.localizedDescription)
            return
        }
        
        print ("User logged in")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }

            if(FBSDKAccessToken.current() == nil){
                print ("token value")
            }
            else{
                print ("no token")
            }
                print ("User is logged in!")


    }
   }
    
    //test function to make sure fb login is working
    func showEmailAddress(){
        let graphRequest = FBSDKGraphRequest(graphPath: "/me" , parameters: ["fields": "id, name, email"]).start {
            (connnection, result, err) in
            if (err != nil){
                print ("Failed to get graph request")
                return
            }
            print(result!)
            if let userDict = result as? NSDictionary{
                self.facebookName = userDict["name"] as? String
            }
            print(self.facebookName!)
        }
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! Auth.auth().signOut()
        print ("User logged out of Facebook")
    
    }


}
//  MARK: - Navigation

// // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        let chatVC = segue.destination as! ChatVC
//        chatVC.senderDisplayName = self.facebookName
//    }
//}



