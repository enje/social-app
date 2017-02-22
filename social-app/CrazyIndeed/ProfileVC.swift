//
//  ProfileVC.swift
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

class ProfileVC: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var usernameLab: UILabel!
    @IBOutlet weak var sexLab: UILabel!
    @IBOutlet weak var ageLab: UILabel!
    @IBOutlet weak var locationLab: UILabel!
    
    //only used if user segues from list of users
    
    @IBOutlet weak var backToUsers: UIButton!
    
    //boolean value to inform whether or not information is for own profile or friend's profile
    var friendProfile = false
    
    //Lets get User Data by getting uid
    var userID: String!//= FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !friendProfile{
            userID = FIRAuth.auth()?.currentUser?.uid
            backToUsers.isHidden = true
        }
        else{
            backToUsers.isHidden = false
        }
        
        //Get the correct table for userID. snapshot is the who table object. It can be treated as a dictionary object
        
        DataService.ds.REF_USERS.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //parse through dictionary object to get values
            if let username = value?["username"] as? String{
                self.usernameLab.text = "Welcome, \(username)"
            }
            if let userlocation = value?["location"] as? String{
                self.locationLab.text = "Location: \(userlocation)"
            }
            if let usersex = value?["sex"] as? String{
                self.sexLab.text = "Sex: \(usersex)"
            }
            if let userage = value?["age"] as? String{
                self.ageLab.text = "Age: \(userage)"
            }
            if let userabout = value?["about"] as? String{
                self.aboutField.text = userabout
            }
            
            //now let's download the image from Firebase Storage
            if let imageLink = value?["imageUrl"] as? String{
                if imageLink != "" {
                    
                    let ref = FIRStorage.storage().reference(forURL: imageLink)
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in
                        if error != nil { print("Unable to download image from Firebase")}
                        else {
                            print("Image download worked")
                            if let imgData = data {
                                if let img = UIImage(data:imgData) {
                                    self.profileImage.image = img
                                }
                            }
                        }
                    })
                }
                else{}
            }
            //done downlodaing image
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Get the correct table for userID. snapshot is the who table object. It can be treated as a dictionary object
        DataService.ds.REF_USERS.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //parse through dictionary object to get values
            if let username = value?["username"] as? String{
                self.usernameLab.text = "Welcome, \(username)"
            }
            if let userlocation = value?["location"] as? String{
                self.locationLab.text = "Location: \(userlocation)"
            }
            if let usersex = value?["sex"] as? String{
                self.sexLab.text = "Sex: \(usersex)"
            }
            if let userage = value?["age"] as? String{
                self.ageLab.text = "Age: \(userage)"
            }
            if let userabout = value?["about"] as? String{
                self.aboutField.text = userabout
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backToUsersPressed(_ sender: Any) {
        if friendProfile{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
