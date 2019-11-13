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
    let switchView = UISwitch(frame: .zero)
    let starView = UIButton(type: UIButton.ButtonType.system)
    
    var objectId:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        switchView.addTarget(self, action: #selector(switchchanged), for: .valueChanged)
        accessoryView = switchView
        
        
        //starView.setImage(UIImage(named: "defaultProfilePic"), for: UIControl.State.normal)
        starView.setTitle("hello", for: UIControl.State.normal)
        starView.addTarget(self, action: #selector(starchanged), for: .touchUpInside)
        //accessoryView = starView
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
        switchView.setOn(user.savedPosts.contains(post.id), animated: false)
        setOn(on:user.savedPosts.contains(post.id))
        /*if(isOn){
            starView.setImage(UIImage(named: "defaultProfilePic"), for: UIControl.State.normal)
        }
        else{
            starView.setImage(UIImage(named: "Image"), for: UIControl.State.normal)
        }*/
    }
    @objc func switchchanged(_ sender: UISwitch!){
        
        //here is where the password tag is set //not sure about this, Im forcibly unwrapping something that couls be nil. can it be nil?? idk... still need to check on that
        if(sender.isOn){
            let postid:String? = ref?.child("Users").child(user.userID).child("savedPosts").childByAutoId().key
            ref?.child("Users").child(user.userID).child("savedPosts").child(postid!).setValue(post.id)
            user.savedPosts.append(post.id)
            user.savedPostsID.append(postid!)
            print(user.savedPosts)
        }
        else{
            let index:Int? = user.savedPosts.firstIndex(of: post.id)
            ref?.child("Users").child(user.userID).child("savedPosts").child(user.savedPostsID[index!]).removeValue()
            user.savedPosts.remove(at: index!)
            user.savedPostsID.remove(at: index!)
        }
    }
    @objc func starchanged(_ sender: UISwitch!){
        
        //here is where the password tag is set //not sure about this, Im forcibly unwrapping something that couls be nil. can it be nil?? idk... still need to check on that
        if(isOn){
            let postid:String? = ref?.child("Users").child(user.userID).child("savedPosts").childByAutoId().key
            ref?.child("Users").child(user.userID).child("savedPosts").child(postid!).setValue(post.id)
            user.savedPosts.append(post.id)
            user.savedPostsID.append(postid!)
            print(user.savedPosts)
        }
        else{
            let index:Int? = user.savedPosts.firstIndex(of: post.id)
            ref?.child("Users").child(user.userID).child("savedPosts").child(user.savedPostsID[index!]).removeValue()
            user.savedPosts.remove(at: index!)
            user.savedPostsID.remove(at: index!)
        }
    }
    
    
}
