//
//  SignInVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/8/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print ("Unable to authenticate with Firebase - \(error)")
            
            } else{
                print("Successfully authenticated with Firebase")
                if let user = user{
                    let userData = ["provider": credential.provider, "email": user.email]
                    self.competeSignIn(user.uid, userData: userData as! Dictionary<String, String>)
                }
            }
        })
    }
    
    func competeSignIn(_ id: String, userData: Dictionary<String, String>){
        //necessary to signin with fb
        DataService.ds.createFirebaseUser(id, userData: userData)
        
        performSegue(withIdentifier: "gotosocial", sender: nil)
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

    

    @IBAction func login(_ sender: Any) {
        print("Login")
        let email = emailField.text
        let pwd = passwordField.text
        
        //see if information is correct using firebase, which searches database for row with correct email and password pair. If it doesn't find it, it returns an error.
        FIRAuth.auth()?.signIn(withEmail: email!, password: pwd!, completion: { (user, error) in
            if error != nil {
                print ("Authentication failed \(error)")
            }
            else{
                //get user data into dictionary for ease of access and then segue to gotosocial
                print("Authentication succeeded")
                if let user = user{
                    let userData = ["provider": user.providerID, "email": user.email]
                    self.competeSignIn(user.uid, userData: userData as! Dictionary<String, String>)
                }
            }
        })
    }
    
    @IBAction func FBLogin(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn (withReadPermissions:["email"], from: self){
            (result, error) in
            if error != nil{
                print ("Facebook login failed. Error \(error)")
            }
            else{
                let accessToken = FBSDKAccessToken.current().tokenString
                print("Successfully logged in with Facebook. \(accessToken)")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken!)
                self.firebaseAuth(credential)
            }
        }
    }
}
