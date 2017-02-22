//
//  EditProfileVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/10/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var editSex: UITextField!
    @IBOutlet weak var editUsername: UITextField!
    @IBOutlet weak var editAge: UITextField!
    @IBOutlet weak var editLocation: UITextField!
    @IBOutlet weak var editAbout: UITextField!
    
    //Lets get User Data by getting uid
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    var imageSelected = false
    var pimagePicker: UIImagePickerController!
    
    var pimageUrl = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pimagePicker =  UIImagePickerController()
        pimagePicker.allowsEditing = true
        pimagePicker!.delegate = self
        
        //Get the correct table for userID. snapshot is the who table object. It can be treated as a dictionary object
        DataService.ds.REF_USERS.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //parse through dictionary object to get values
            if let username = value?["username"] as? String{
                self.editUsername.text = username
            }
            if let userlocation = value?["location"] as? String{
                self.editLocation.text = userlocation
            }
            if let usersex = value?["sex"] as? String{
                self.editSex.text = usersex
            }
            if let userage = value?["age"] as? String{
                self.editAge.text = userage
            }
            if let userabout = value?["about"] as? String{
                 self.editAbout.text = userabout
            }
            
            if let imageLink = value?["imageUrl"] as? String{
                if imageLink != "" {
                    //get image link from database
                    let ref = FIRStorage.storage().reference(forURL: imageLink)
                    
                    //check size constraints
                    ref.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
                        if error != nil {
                            print("Unable to download image")
                        }
                        else{
                            //set up data object and pass it into uiimage constructor
                            if let imageData = data{
                                if let img = UIImage(data: imageData){
                                    self.pImage.image = img
                                }
                            }
                        }
                    })
                }
            }
            else{
                print("Image is nil")
            }
        
        }) {(error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with even: UIEvent?){
        if let touch = touches.first {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, with: even)
    }
    
    func textFieldShoudlReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            pImage.image = image
            imageSelected = true    //see whether or not to upload it to the database
        }
        else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imgTap(_ sender: Any) {
        print("Image tapped")
        present(pimagePicker, animated: true, completion: nil)
    }

    @IBAction func submitButton(_ sender: Any) {
        //write to database
        
      DataService.ds.REF_USERS.child(userID!).child("username").setValue(self.editUsername.text)
        
      DataService.ds.REF_USERS.child(userID!).child("location").setValue(self.editLocation.text)
        
        DataService.ds.REF_USERS.child(userID!).child("sex").setValue(self.editSex.text)
        
        DataService.ds.REF_USERS.child(userID!).child("age").setValue(self.editAge.text)
        
        DataService.ds.REF_USERS.child(userID!).child("about").setValue(self.editAbout.text)
        
        let img = pImage.image
        //only save if image was selected
        if imageSelected == true{
            if let imageData = UIImageJPEGRepresentation(img!, 0.2 /*compression factor*/){
                let imgUid = NSUUID().uuidString
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg" //explicitely set it as a jpeg
                
                DataService.ds.REF_USER_PICS.child(imgUid).put(imageData, metadata: metaData as FIRStorageMetadata?){
                    (metadata, error) in
                    
                    if error != nil{
                        print("error \(error)")
                    }
                    else{
                        let downloadUrl = metadata?.downloadURL()?.absoluteString
                        DataService.ds.REF_USERS.child(self.userID!).child("imageUrl").setValue(downloadUrl)
                    }
                    
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
