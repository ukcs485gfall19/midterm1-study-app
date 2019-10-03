//
//  CellViewController.swift
//  messagingApp
//
//  Created by Kye Miller on 9/28/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
// fix commit

import UIKit
import FirebaseDatabase

//var finalName = ""
class CellViewController: UIViewController {
    
    @IBOutlet weak var test: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    
    var ref:DatabaseReference?
    
    var postId = "" // INITIALIZE BLANK OBJECT FOR SEGUE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        
        ref?.child("Posts").child(postId).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //setting body
            let body = value?["Body"] as? String ?? "Body Placeholder"
            self.test.text = body
            
            //setting title
            let title = value?["Title"] as? String ?? "Title Placeholder"
            self.titleLabel.text = title
            
            //setting course
            let major = value?["Major"] as? String ?? "Course"
            let theClass = value?["Class"] as? String ?? "Class"
            self.courseLabel.text = "Course: " + major + " " + theClass
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
