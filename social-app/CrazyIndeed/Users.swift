//
//  Users.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/20/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class Users{
    private var _username: String!
    private var _about: String!
    private var _imgUrl: String!
    private var _key: String!
    private var _userRef: FIRDatabaseReference!
    
    var username: String{
        return _username
    }
    
    var key: String{
        return _key
    }
    
    var about: String{
        return _about
    }
    
    var imgUrl: String{
        return _imgUrl
    }
    
    init(username:String, imgUrl:String, about: String){
        self._username = username
        self._imgUrl = imgUrl
        self._about = about
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        self._key = key
        if let about = dictionary["about"] as? String{
            self._about = about
        }
        if let user = dictionary["username"] as? String{
            self._username = user
        }
        if let imgUrl = dictionary["imageUrl"] as? String{
            if imgUrl != nil {
                self._imgUrl = imgUrl
            }
            else{
                self._imgUrl = ""
            }
            
        }
        self._userRef = DataService.ds.REF_USERS.child(self._key)
    }
    
    

}
