//
//  ComposeViewController.swift
//  messagingApp
//
//  Created by Joshua Steinbach on 9/25/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
// fix commit

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        
        bodyTextField.text = "Body"
        bodyTextField.textColor = UIColor.lightGray
        
        bodyTextField.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bodyTextField.text == "Body"{
            bodyTextField.text = ""
            bodyTextField.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bodyTextField.text == ""{
            bodyTextField.text = "Body"
            bodyTextField.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func addPost(_ sender: Any) {
        //add to database
        if titleTextField.text != "" {
            //create a new child with an auto-generated id
            let id:String? = ref?.child("Posts").childByAutoId().key
            
            //here is where the body tag is set
            ref?.child("Posts").child(id!).child("Body").setValue(bodyTextField.text) //not sure about this, Im forcibly unwrapping something that couls be nil. can it be nil?? idk... still need to check on that
            
            //here is where the title tag is set
            ref?.child("Posts").child(id!).child("Title").setValue(titleTextField.text)
            
            //additional fields can be added here when needed
        }
        //close popup
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        //close popup
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
