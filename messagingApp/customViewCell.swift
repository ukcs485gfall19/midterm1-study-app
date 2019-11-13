//
//  customViewCell.swift
//  messagingApp
//
//  Created by Kilgore on 10/29/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit
import FirebaseDatabase

class customViewCell: UITableViewCell {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var footer: UILabel!
    var ref:DatabaseReference?
    var post = Post()
    var user = User()
    let switchView = UISwitch(frame: .zero)
    var isOn = false
    
    var objectId:String=""
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        
        switchView.setOn(false, animated: true)
        switchView.addTarget(self, action: #selector(switchchanged), for: .valueChanged)
        accessoryView = switchView
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func load(){
        header.text = post.title
        footer.text = post.desc
    }
    @objc func switchchanged(_ sender: UISwitch!){
        
        //here is where the password tag is set //not sure about this, Im forcibly unwrapping something that couls be nil. can it be nil?? idk... still need to check on that
        if(sender.isOn){
            ref?.child("Users").child(user.userID).child("savedPost").setValue(post.id)
            user.savedPost = post
        }
        else{
            
        }
    }
    
    
}
