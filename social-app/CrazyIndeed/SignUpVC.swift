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
    
    var qAndaList = [QAndA]()    //lists questions
    var maxQuestionCount = 2
    
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
    
    func getQuestions(){
        //retrieve questions
        DataService.ds.REF_QANDA.observe(.value, with: { (snapshot) in
            self.qAndaList = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let qandaDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let qanda = QAndA(key: key, dictionary: qandaDict)
                        self.qAndaList.append(qanda)
                        
                        print("Question:" + String(qanda.question))
                        
                        print("Questions: " + String(self.qAndaList.count))
                    }
                    
                    if self.qAndaList.count >= self.maxQuestionCount{
                        self.performSegue(withIdentifier: "fromSignupToQuestions", sender: self)
                    }
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue")
        if (segue.identifier == "fromSignupToQuestions") {
            print("Prepare for segue1")
            if let viewController: SignupQuestionsVC = segue.destination as? SignupQuestionsVC {
                print("Prepare for segue2")
                viewController.qAndaList = qAndaList
            }
        }
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
                        let userData = ["provider": user.providerID, "username": "", "email": user.email, "age": "","location": "", "about": "", "imageUrl": "", "status": "active", "sex": "", "newUser": "yes"]
                        
                        DataService.ds.createFirebaseUser(user.uid, userData: userData as! Dictionary<String, String>)
                        
                        //has to generate questions before going to next page
                        self.getQuestions()
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
