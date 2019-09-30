//
//  ComposeViewController.swift
//  messagingApp
//
//  Created by Joshua Steinbach on 9/25/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPost(_ sender: Any) {
        //add to database
        if textView.text != "" {
            //ref?.child("Posts").childByAutoId().setValue(textView.text)

            let id:String? = ref?.child("Posts").childByAutoId().key
            ref?.child("Posts").child(id!).child("Body").setValue(textView.text) //not sure about this, Im forcibly unwrapping something that couls be nil. can it be nil?? idk...
            ref?.child("Posts").child(id!).child("Title").setValue("Hi, I'm a title")
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