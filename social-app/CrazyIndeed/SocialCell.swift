//
//  SocialCell.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/15/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class SocialCell: UITableViewCell, UINavigationControllerDelegate {
    
    @IBOutlet weak var socialImg: UIImageView!
    
    @IBOutlet weak var socialTitle: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userLoc: UILabel!
    
    @IBOutlet weak var socialDescription: UILabel!
    
    @IBOutlet weak var socialCat: UILabel!
    
    @IBOutlet weak var socialLikeCount: UILabel!
    
    @IBOutlet weak var socialCommentsCounts: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var flagButton: UIButton!
    
    var Social: Social!
    
    var likeRef: FIRDatabaseReference!
    var flagRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(social: Social, img: UIImage? = nil){
        self.Social = social
        
        //get database information
        let userID = FIRAuth.auth()?.currentUser?.uid
        likeRef = DataService.ds.REF_USERS.child(userID!).child("likes").child(social.socialKey)
        flagRef = DataService.ds.REF_USERS.child(userID!).child("flags").child(social.socialKey)
        
        self.socialTitle.text = social.title
        self.socialDescription.text = social.description
        self.socialCat.text = "Category: \(social.category)"
        
        let likecount = String(social.likes)
        self.socialLikeCount.text = "\(likecount) Likes"
        
        self.userName.text! = "Posted by: " + social.username
        self.userLoc.text! = "Posted from: " + social.location
        
        if img != nil{
            self.socialImg.image = img
        }
        else{
            let imgUrl = social.imgUrl
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
                                self.socialImg.image = img
                                //put images into cache so they don't have to be redownloaded when table view is moved up and down
                                //socialVC.imageCache.setObject(img, forKey: social.imgUrl as NSString)
                            }
                        }
                    }
                })
            }
            else{
                self.socialImg.isHidden = true
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //the view for the selected state
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likeAction(_ sender: Any) {
        //first change the like button from like to liked or liked to like
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let doesNotExist = snapshot.value as? NSNull{
                self.likeButton.setTitle("Joined", for: .normal)
                self.Social.adjustLike(addLike: false)
                self.likeRef.setValue(true)
            }
            else{
                self.likeButton.setTitle("Join", for: .normal)
                self.Social.adjustLike(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
    
    @IBAction func flagAction(_ sender: Any) {
        flagRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let doesNotExistF = snapshot.value as? NSNull{
                self.flagButton.setTitle("Flagged", for: .normal)
                self.Social.adjustFlags(addFlag: true)
                self.flagRef.setValue(true)
            }
            else{
                self.flagButton.setTitle("Flag", for: .normal)
                self.Social.adjustFlags(addFlag: true)
                self.flagRef.removeValue()
            }
        })
    }
}
