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
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var ref:DatabaseReference?
    var postId = "" // INITIALIZE BLANK OBJECT FOR SEGUE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        //noting small change i made here, added spaces to the beginning of each text field to make them look better
        ref?.child("Posts").child(postId).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //setting body
            let body = value?["Body"] as? String ?? "Body Placeholder"
            self.test.text = " " + body
            
            //setting title
            let title = value?["Title"] as? String ?? "Title Placeholder"
            self.titleLabel.text = "  " + title
            
            //setting course
            let prefix = value?["Prefix"] as? String ?? "Prefix"
            let number = value?["Number"] as? String ?? "Number"
            self.courseLabel.text = "  Course: " + prefix + " " + number
            
            //setting date/location
            let location = value?["Location"] as? String ?? "Location Placeholder"
            self.locLabel.text = "  Location: " + location
            let date = value?["Date"] as? String ?? "Date Placeholder"
            self.dateLabel.text = "  " + date
            

            let labelHolster:[UILabel] = [self.titleLabel,self.courseLabel,self.locLabel,self.dateLabel]
            //setting some nice boundaries
            for currLabel in labelHolster{
                currLabel.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
                currLabel.layer.borderWidth = 0.5
            }
            
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
