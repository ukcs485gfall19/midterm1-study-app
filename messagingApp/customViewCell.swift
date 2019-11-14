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
    var isOn:Bool = false
    @IBOutlet weak var starButton: UIButton!
    var objectId:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        starButton.addTarget(self, action: #selector(starred), for: .touchUpInside)
        starButton.setImage(UIImage(named: "starHollow"), for: UIControl.State.normal)
        starButton.setTitle("Hello", for: UIControl.State.normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOn(on:Bool){
        isOn = on
    }
    
    func load(){
        header.text = post.title
        footer.text = post.desc
        setOn(on:user.savedPosts.contains(post.id))
        if(!isOn){
            starButton.setImage(UIImage(named: "starHollow"), for: UIControl.State.normal)
        }
        else{
           starButton.setImage(UIImage(named: "starFilled"), for: UIControl.State.normal)
        }
    }
    @objc func starred(_ sender: UIButton){
        isOn = !isOn
        if(isOn){
            let postid:String? = ref?.child("Users").child(user.userID).child("savedPosts").childByAutoId().key
            ref?.child("Users").child(user.userID).child("savedPosts").child(postid!).setValue(post.id)
            user.savedPosts.append(post.id)
            user.savedPostsID.append(postid!)
        }
        else{
            let index:Int? = user.savedPosts.firstIndex(of: post.id)
            ref?.child("Users").child(user.userID).child("savedPosts").child(user.savedPostsID[index!]).removeValue()
            user.savedPosts.remove(at: index!)
            user.savedPostsID.remove(at: index!)
        }
        load()
    }
    
    
}
