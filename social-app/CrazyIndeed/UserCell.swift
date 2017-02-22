//
//  UserCell.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/20/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class UserCell: UITableViewCell {
    
    @IBOutlet weak var usernameLab: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var aboutLab: UILabel!
    
    var Users: Users!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(users: Users, img: UIImage? = nil){
        self.Users = users
        
        //get database information
        //let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.usernameLab.text = "Username: " + users.username
        self.aboutLab.text = "About: " + users.about
 
        
        if img != nil{
            self.userImage.image = img
        }
        else{
            let imgUrl = users.imgUrl
            if imgUrl != ""{
                let ref = FIRStorage.storage().reference(forURL: imgUrl)
                ref.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
                    if error != nil {
                        print("Unable to download image from Firebase")
                    }
                    else{
                        print("Image download worked!")
                        if let imgData = data{
                            if let img = UIImage(data:imgData){
                                self.userImage.image = img
                                //put images into cache so they don't have to be redownloaded when table view is moved up and down
                                UsersVC.imageCache.setObject(img, forKey: users.imgUrl as NSString)
                            }
                        }
                    }
                })
            }
            else{
                self.userImage.image = UIImage(named: "default-user-image")
            }
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
