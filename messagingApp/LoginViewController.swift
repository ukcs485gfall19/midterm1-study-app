//
//  LoginViewController.swift
//  messagingApp
//
//  Created by Kilgore on 11/5/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newUser: UIButton!
    //adding references
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var model = postModel()
    //making the username for the segue
    var userSegue = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add reference and load in usernames/passwords
        //model.loadData()
        ref = Database.database().reference()
        databaseHandle = ref?.child("Users").observe(.childAdded, with: { (snapshot) in
            let postId = snapshot.key
            let value = snapshot.value as? NSDictionary
            let newPost = User()
            newPost.userName = value?["Username"] as? String ?? "useruser"
            newPost.password = value?["Password"] as? String ?? "passpass"
            newPost.userID = postId
            self.model.users.append(newPost)
        })
        newUser.addTarget(self, action:#selector(newUserAdded), for: .touchUpInside)
        loginButton.addTarget(self,action:#selector(loginTo),for: .touchUpInside)
        cancelButton.addTarget(self, action:#selector(exitScreen), for: .touchUpInside)
        userText.delegate = self
        passText.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func exitScreen(sender:UIButton){
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginTo(sender:UIButton){
        var userName:String = ""
        var passWord:String = ""
        for testuser in model.users{
            if(testuser.userName == userText.text && testuser.password == passText.text){
                userSegue = testuser
                userName = testuser.userName
                passWord = testuser.password
            }
        }
        if(userName != "" && passWord != ""){
            performSegue(withIdentifier: "returnView", sender: self)
        }
        else{
            let alertController = UIAlertController(title: "Alert", message: "Incorrect username or password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func newUserAdded(sender:UIButton){
        if userText.text != "" && passText.text != ""{
            for check in model.users{
                if(userText.text == check.userName){
                    let alertController = UIAlertController(title: "Alert", message: "Username Taken", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
           //create a new child with an auto-generated id
           let id:String? = ref?.child("Users").childByAutoId().key
            let newuser = User()
           
           //here is where the password tag is set
           ref?.child("Users").child(id!).child("Password").setValue(passText.text) //not sure about this, Im forcibly unwrapping something that couls be nil. can it be nil?? idk... still need to check on that
            newuser.password = passText.text
            
           //here is where the username tag is set
           ref?.child("Users").child(id!).child("Username").setValue(userText.text)
            newuser.userName = userText.text
            //should automatically log the user in after creating account
            newuser.userID = id!
           userSegue = newuser
           performSegue(withIdentifier: "returnView", sender: self)
       }
       else{
           let alertController = UIAlertController(title: "Alert", message: "Please fill out all requred fields", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Ok", style: .default))
           self.present(alertController, animated: true, completion: nil)
       }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.user = self.userSegue
        vc.navItem.title = vc.user.userName
    }

}
