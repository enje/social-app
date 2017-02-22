//
//  UsersVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/17/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var users: UITableView!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var userList = [Users]()    //lists users
    var inde = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users.dataSource = self
        users.delegate = self
        
        DataService.ds.REF_USERS.observe(.value, with: { (snapshot) in
            self.userList = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let userDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let user = Users(key: key, dictionary: userDict)
                        self.userList.append(user)
                    }
                    self.inde += 1
                    print(self.inde)
                }
            }
            self.users.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = userList[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell{
            if let img = UsersVC.imageCache.object(forKey: user.imgUrl as NSString){
                cell.configureCell(users: user, img: img)
            }
            else{
                cell.configureCell(users: user)
            }
            print("User cell")
            return cell
        }
        else{
            return UserCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath as IndexPath) {
            self.performSegue(withIdentifier: "toUserInformation", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserInformation"{
            if let destination = segue.destination as? ProfileVC{
                let path = users.indexPathForSelectedRow
                let user = userList[path!.row]
                
                destination.friendProfile = true
                destination.userID = user.key
            }
        }
    }
}
