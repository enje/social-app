//
//  SignUpVC.swift
//  CrazyIndeed
//
//  Created by Gabe Aron on 2/9/17.
//  Copyright © 2017 Gabe Aron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpVC: UIViewController {


    
    @IBOutlet weak var emailF: UITextField!
    
    @IBOutlet weak var passwordF: UITextField!
    
    @IBOutlet weak var pwVarifyF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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


    @IBAction func submit(_ sender: Any) {
        //pw's have to match
        if String(describing: passwordF.text) != String(describing: pwVarifyF.text){
            print("Passwords don't match")
        }
        else{
            let email = emailF.text
            let pass = passwordF.text
            
            //pass information into firebase and see if it accepts information
            FIRAuth.auth()?.createUser(withEmail: email!, password: pass!, completion: { (user, error) in
                if error != nil{
                    print("Unable to create user \(error)")
                }
                else{
                    print("Successfully created user")
                    //make dictionary with fields for a user table with the generated user object
                    if let user = user{
                        let userData = ["provider": user.providerID, "username": "", "email": user.email, "age": "", "location": "", "about": "", "imageUrl": "", "status": "active", "sex": "", "newUser": "yes"]
                        
                        DataService.ds.createFirebaseUser(user.uid, userData: userData as! Dictionary<String, String>)
                    }
                }
            })
        }
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
