//
//  postModel.swift
//  messagingApp
//
//  Created by Kilgore on 11/12/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit
import FirebaseDatabase

class postModel: NSObject{
    var posts = [Post]() //holds a list of database posts
    var postIDS = [String]()
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    
    func loadDataWithView(view: ViewController) {
        ref = Database.database().reference()
        //retrieve posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let postId = snapshot.key
            let value = snapshot.value as? NSDictionary
            let newPost = Post()
            newPost.title = value?["Title"] as? String ?? "Title Placeholder"
            newPost.desc = value?["Body"] as? String ?? "Body Placeholder"
            newPost.id = postId
            newPost.location = value?["Location"] as? String ?? "Location Placeholder"
            newPost.number = value?["Number"] as? String ?? "Number Placeholder"
            newPost.date = value?["Prefix"] as? String ?? "Prefix Placeholder"
            newPost.prefix = value?["Date"] as? String ?? "Date Placeholder"
            self.postIDS.append(postId)
            self.posts.append(newPost)
            view.tableView.reloadData()
            
        })
    }
    func gimmeTitles() -> [String]{
        var returnguy = [String]()
        for posts in posts{
            returnguy.append(posts.title)
        }
        return returnguy
    }
    func gimmePostID() -> [String]{
        var returnguy = [String]()
        for posts in posts{
            returnguy.append(posts.id)
        }
        print(returnguy)
        return returnguy
    }
}
