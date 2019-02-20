//
//  RegistraionVC.swift
//  Chat
//
//  Created by lobna on 12/18/18.
//  Copyright © 2018 lobna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SVProgressHUD

class RegistraionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
        SVProgressHUD.show()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imageController = UIImagePickerController()
            imageController.delegate = self
            imageController.allowsEditing = true
            imageController.sourceType = .photoLibrary
            self.present(imageController, animated: true, completion: nil)
        }else{
            errorMsg(msg: "You don't have permission to access the gallery")
        }
        SVProgressHUD.dismiss()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userImage.image = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            userImage.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    var imageRefrence: StorageReference{
        return Storage.storage().reference().child("Profile Pictures")
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            if error != nil{
                SVProgressHUD.dismiss()
                self.errorMsg(msg: "Something went wrong while registration")
            }else{
                guard let profileImage = self.userImage.image else {return}
                guard let imageData = profileImage.jpegData(compressionQuality: 1) else {return}
                let imageName = NSUUID().uuidString
                let uploadImageRef = self.imageRefrence.child("\(imageName).jpg")
                _ = uploadImageRef.putData(imageData, metadata: nil, completion: nil)
                self.performSegue(withIdentifier: "goToChat", sender: self)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func errorMsg(msg: String){
        let alert  = UIAlertController(title: "Warning", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
