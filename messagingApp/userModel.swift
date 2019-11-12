//
//  userModel.swift
//  messagingApp
//
//  Created by Kilgore on 11/12/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit
import FirebaseDatabase

class userModel: NSObject {
    
    var posts = [User]() //holds a list of database users
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    
    func loadData() {
        ref = Database.database().reference()
        //retrieve posts and listen for changes
        databaseHandle = ref?.child("User").observe(.childAdded, with: { (snapshot) in
            let postId = snapshot.key
            let value = snapshot.value as? NSDictionary
            let newPost = User()
            newPost.userName = value?["Username"] as? String ?? "useruser"
            newPost.password = value?["Password"] as? String ?? "passpass"
            newPost.userID = postId
            self.posts.append(newPost)
            
        })
    }
}
