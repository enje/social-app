//
//  LandingVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/15/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LandingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logout(_ sender: Any) {
        //signout is the logout method for the current user
        try! FIRAuth.auth()?.signOut()
        
        //Remove the user's uid from storage
        UserDefaults.standard.setValue(nil, forKey:"uid")
        
        //head back to Login!
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
}
