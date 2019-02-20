//
//  WelcomeVC.swift
//  Chat
//
//  Created by lobna on 12/18/18.
//  Copyright © 2018 lobna. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase

class WelcomeVC: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var FBOutlet: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        FBOutlet.delegate = self
    }
  
    @IBAction func FBBtn(_ sender: UIButton) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil{
                print("Didn't log in \(error)")
                return
            }
            if !((result?.isCancelled)!){
                let accessToken = FBSDKAccessToken.current()
                let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
                Auth.auth().signInAndRetrieveData(with: credentials, completion: { (user, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    print("Successfull FB on Firebase")
                })
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"])?.start(completionHandler: { (connection, result, error) in
                    if error != nil{
                        print("Failed to start graph request: \(error)")
                        return
                    }
                    print(result)
                })
                self.performSegue(withIdentifier: "goToChatList", sender: self)
            }
        }
    }
    
    @IBAction func GoogleBtn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
        performSegue(withIdentifier: "goToChatList", sender: self)
    }
    
    
    
     //MARK: - Facebook Delegate Methods
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if !((result?.isCancelled)!){
            let accessToken = FBSDKAccessToken.current()
            let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
            Auth.auth().signInAndRetrieveData(with: credentials, completion: { (user, error) in
                if error != nil{
                    print("\(error)")
                    return
                }
                print("Successfull FB on Firebase")
            })
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"])?.start(completionHandler: { (connection, result, error) in
                if error != nil{
                    print("Failed to start graph request: \(error)")
                    return
                }
            })
            self.performSegue(withIdentifier: "goToChatList", sender: self)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}
