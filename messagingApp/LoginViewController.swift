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
    //adding double arrays
    var userIDArr = [String]()
    var userArr = [String]()
    var passArr = [String]()
    //making the username for the segue
    var userSegue:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add reference and load in usernames/passwords
        ref = Database.database().reference()
        databaseHandle = ref?.child("Users").observe(.childAdded, with: { (snapshot) in
            let postId = snapshot.key
            self.userIDArr.append(postId)
            let value = snapshot.value as? NSDictionary
            self.userArr.append(value?["Username"] as? String ?? "null")
            self.passArr.append(value?["Password"] as? String ?? "null")
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
        var passIndex:Int = 0
        for testUsers in userArr{
            if(testUsers == userText.text){
                userName = testUsers
                passIndex = userArr.firstIndex(of: userName) ?? 0
            }
        }
        if(passArr[passIndex] == passText.text){
            passWord = passArr[passIndex]
        }
        if(userName != "" && passWord != ""){
           userSegue = userName
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
            for check in userArr{
                if(userText.text == check){
                    let alertController = UIAlertController(title: "Alert", message: "Username Taken", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
           //create a new child with an auto-generated id
           let id:String? = ref?.child("Users").childByAutoId().key
           
           //here is where the password tag is set
           ref?.child("Users").child(id!).child("Password").setValue(passText.text) //not sure about this, Im forcibly unwrapping something that couls be nil. can it be nil?? idk... still need to check on that
           
           //here is where the username tag is set
           ref?.child("Users").child(id!).child("Username").setValue(userText.text)
            
            //should automatically log the user in after creating account
            userSegue = userText.text
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
            vc.userID = self.userSegue
        vc.navItem.title = vc.userID
    }

}
