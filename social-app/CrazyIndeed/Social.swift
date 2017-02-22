//
//  Social.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/15/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class Social{
    private var _title: String!
    private var _description: String!
    private var _location: String!
    private var _category: String!
    private var _socialKey: String!
    private var _username: String!
    private var _imgUrl: String!
    private var _likes: Int!
    private var _flags: Int!
    private var _commentCount: Int?
    private var _socialRef: FIRDatabaseReference!
    
    var title: String{
        return _title
    }
    
    var description: String{
        return _description
    }
    
    var location: String{
        return _location
    }
    
    var category: String{
        return _category
    }
    
    var username: String{
        return _username
    }
    
    var socialKey: String{
        return _socialKey
    }
    
    var imgUrl: String{
        return _imgUrl
    }
    
    var likes: Int!{
        return _likes
    }
    
    var flags: Int!{
        return _flags
    }
    
    var commentCount: Int?{
        return _commentCount
    }
    
    init(title:String, location: String, Category: String, username:String, imgUrl:String, commentCount:Int?){
        self._title = title
        self._description = description
        self._username = username
        self._imgUrl = imgUrl
        self._commentCount = commentCount
    }
    
    init(socialKey: String, dictionary: Dictionary<String, AnyObject>){
        self._socialKey = socialKey
        if let desc = dictionary["description"] as? String{
            self._description = desc
        }
        if let tit = dictionary["title"] as? String{
            self._title = tit
        }
        if let loc = dictionary["location"] as? String{
            self._location = loc
        }
        
        if let cat = dictionary["category"] as? String{
            self._category = cat
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
        if let likes = dictionary["likes"] as? Int{
            self._likes = likes
        }
        if let flags = dictionary["flags"] as? Int{
            self._flags = flags
        }
        if let commentDic = dictionary["comments"] as? Dictionary <String, AnyObject>{
            self._commentCount = commentDic.count
        }
        self._socialRef = DataService.ds.REF_SOCIALS.child(self._socialKey)
    }
    
    func adjustLike(addLike: Bool){
        if addLike{
            _likes = _likes! + 1
        }
        else{
            _likes = _likes! - 1
        }
        
        _socialRef.child("likes").setValue(_likes)
    }
    
    func adjustFlags(addFlag:Bool){
        if addFlag{
            _flags = _flags! + 1
        }
        else{
            _flags = _flags! - 1
        }
        
        _socialRef.child("flags").setValue(_flags)
    }
}
