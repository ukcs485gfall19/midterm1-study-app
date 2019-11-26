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
    var model = postModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        //noting small change i made here, added spaces to the beginning of each text field to make them look better
        //setting body
        let value = model.posts[model.postIDS.firstIndex(of: postId)!]
        self.test.text = value.desc
        
        //setting title
        self.titleLabel.text = "  " + value.title
        
        //setting course
        self.courseLabel.text = "  Course: " + value.prefix + " " + value.number
        
        //setting date/location
        self.locLabel.text = "  Location: " + value.location
        self.dateLabel.text = "  " + value.date + "-" + value.endTime.dropFirst(16)
        

        let labelHolster:[UILabel] = [self.titleLabel,self.courseLabel,self.locLabel,self.dateLabel]
        //setting some nice boundaries
        for currLabel in labelHolster{
            currLabel.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
            currLabel.layer.borderWidth = 0.5
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

}
