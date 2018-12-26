//
//  ChatVC.swift
//  Chat
//
//  Created by lobna on 12/19/18.
//  Copyright © 2018 lobna. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import ChameleonFramework
import SVProgressHUD

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var messageArray : [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableVieweTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
//        firstViewController.navigationController.viewControllers = [NSArray arrayWithObject: secondViewController];

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        
        retrieveMessage()
        
        messageTableView.separatorStyle = .none
        
        let addButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutBtn))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendBtn.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text]
        
        messageDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil{
                print(error)
                return
            }
            self.messageTextfield.isEnabled = true
            self.messageTextfield.text = ""
            self.sendBtn.isEnabled = true
        }
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        messageTextfield.endEditing(true)
//    }
    
    //MARK: - TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - UITableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].Body
        cell.sendeerUsername.text = messageArray[indexPath.row].Sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.sendeerUsername.text == Auth.auth().currentUser?.email as String!{
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    @objc func tableVieweTapped(){
        messageTextfield.endEditing(true)
    }
    
    func configureTableView(){
        messageTableView.estimatedRowHeight = 120.0
//        messageTableView.rowHeight = UITableAuto
    }
    
    //Create the retrieveMessages method
    func retrieveMessage(){
        SVProgressHUD.show()
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.Body = text
            message.Sender = sender
            self.messageArray.append(message)
            self.messageTableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @objc func logoutBtn(){
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            FBSDKLoginManager().logOut()
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print(error)
        }
    }

}
