//
//  socialVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/13/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class socialVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //variable declaration
    var currentUsername = ""
    var newUser:Bool = false
    var socials = [Social]()
    var socialR = [Social]() //needed for sort the social posts by date
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var profileUserName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 800
        
        DataService.ds.REF_SOCIALS.observe(.value, with: { (snapshot) in
            self.socials = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let socialDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let social = Social(socialKey: key, dictionary: socialDict)
                        self.socials.append(social)
                    }
                }
            }
            self.socialR = self.socials.reversed()
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let social = socialR[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell") as? SocialCell{
            if let img = socialVC.imageCache.object(forKey: social.imgUrl as NSString){
                cell.configureCell(social: social, img: img)
            }
            else{
                cell.configureCell(social: social)
            }
            return cell
        }
        else{
            return SocialCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath) {
            self.performSegue(withIdentifier: "CommentSegue", sender: self)
        }
    }
    
}
