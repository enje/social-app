//
//  DataService.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/9/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//
// Contains specifics for communicating with firebase. Firebase has both database and storage: where files refered to are located

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class DataService {
    static let ds = DataService()
    
    //database references
    private var _REF_BASE = FIRDatabase.database().reference()  //the root of the database
    private var _REF_SOCIALS = FIRDatabase.database().reference().child("Socials")
    private var _REF_USERS = FIRDatabase.database().reference().child("Usesrs") //list of users
    
    //storage reference
    private var _REF_SOCIAL_PICS = FIRStorage.storage().reference().child("socialPics")
    private var _REF_USER_PICS = FIRStorage.storage().reference().child("userPics") //picture locations for each user
    
    //getter functions
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_SOCIALS: FIRDatabaseReference{
        return _REF_SOCIALS
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_SOCIAL_PICS: FIRStorageReference{
        return _REF_SOCIAL_PICS
    }
    
    var  REF_USER_PICS: FIRStorageReference{
        return  _REF_USER_PICS
    }
    
    //creates user with user id and user inforation as a dictionary
    func createFirebaseUser(_ uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)    //take _REF_USERS and update child values to add new user
    }
}
