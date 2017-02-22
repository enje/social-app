//
//  CreatePost.swift
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

class CreatePost: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleLab: UITextField!
    
    @IBOutlet weak var descLab: UITextField!
    
    
    @IBOutlet weak var locLab: UITextField!
    
    
    @IBOutlet weak var category: UIPickerView!
    
    
    @IBOutlet weak var postImage: UIImageView!
    
    //find user id
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    //categories for picker view
    let pickerData = ["a", "b", "c", "d", "e", "f"]
    
    //determines wheather to load image into database
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    var cat = ""
    var imgDownloadURL = ""
    var currentUsername = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        category.delegate = self
        category.dataSource = self
        
        //get user imformation from firebase
        DataService.ds.REF_USERS.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //get name of user who submitted post
            if let username = value?["username"] as? String{
                self.currentUsername = username
            }
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    //go to user's photolibrary to select an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            postImage?.image = image
            imageSelected = true
        }
        else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //keyboard hide
    override func touchesBegan(_ touches: Set<UITouch>, with even: UIEvent?){
        self.view.endEditing(true)
    }
    
    //let's setup picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cat = pickerData[row]
    }
    
    // Extra code to style UIPickerView
    
    
    
    private func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = pickerData[row]
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blue])
        
        return myTitle
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as! UILabel!
        
        if view == nil {  //if no label there yet
            
            pickerLabel = UILabel()
            
            //color the label's background
            
            let hue = CGFloat(row)/CGFloat(pickerData.count)
            
            pickerLabel?.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            
        }
        
        let titleData = pickerData[row]
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.black])
        
        pickerLabel!.attributedText = myTitle
        
        pickerLabel!.textAlignment = .center
        
        
        
        return pickerLabel!
        
        
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 28.0
        
    }
    
    // for best use with multitasking , dont use a constant here.
    
    //this is for demonstration purposes only.
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return 200
        
    }
    
    // Done with that Styling of pickerview
    
    func postToFirebase(imgURL: String){
        //first we create a disctionary
        var social: Dictionary<String, AnyObject> = [
            "title": titleLab.text! as AnyObject,
            "description": descLab.text! as AnyObject,
            "username": currentUsername as AnyObject,
            "location": locLab.text! as AnyObject,
            "category": cat as AnyObject,
            "likes": 0 as AnyObject,
            "flags": 0 as AnyObject
        ]
        
        //put image string in the dictionary
        //if image selected, put image string in dictionary
        if imageSelected == true{
            social["imageUrl"] = imgURL as AnyObject
        }
        //if not, put in blank string
        else{
            social["imageUrl"] = "" as AnyObject
        }
        
        //put dictionary onto firebase db
        DataService.ds.REF_SOCIALS.childByAutoId().setValue(social)
        {(metadata, error) in
            if error != nil {print("Post not saved to db")}
            else{
                print("Post saved to db")
            }
        }

    }
    

    
    @IBAction func imageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        guard let title = titleLab.text, title != "" else {
            print("Title can't be empty")
            return
        }
        
        guard let desc = descLab.text, desc != "" else {
            print("Say something, dammit!")
            return
        }
        
        let img = postImage?.image
        if imageSelected == true{
            if let imgData = UIImageJPEGRepresentation(img!, 0.2){
                let imgUid = NSUUID().uuidString
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                DataService.ds.REF_SOCIAL_PICS.child(imgUid).put(imgData, metadata: metaData as FIRStorageMetadata?) {(metadata, error) in
                    
                    if error != nil {print("Image was not uploaded to Firebase")}
                    else{
                        print("Image was successfully uploaded to Firebase")
                        
                        let downloadurl = metadata?.downloadURL()?.absoluteString
                        if let url = downloadurl {
                            print ("postToFirebase")
                            self.postToFirebase(imgURL: url)
                        }
                    }
                }
            }
        }
        else{
            let url = ""
            self.postToFirebase(imgURL: url)
        }
        //go to previous vc
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        //go to previous vc
        dismiss(animated: true, completion: nil)
    }

}
