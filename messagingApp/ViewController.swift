//
//  ViewController.swift
//  messagingApp
//
//  Created by Joshua Steinbach on 9/12/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.


import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var postData = [String]()
    var passMe = ""
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navItem.title = "Posts"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //set the firebase reference
        ref = Database.database().reference()
        
        //retrieve posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let postId = snapshot.key
            self.postData.append(postId)
            self.tableView.reloadData()
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        ref?.child("Posts").child(postData[indexPath.row]).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let title = value?["Title"] as? String ?? "Title Placeholder"
            cell?.textLabel?.text = title //this is what actually gets put in the cell
        })
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        passMe = postData[indexPath.row]
        performSegue(withIdentifier: "segue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue" {
        let vc = segue.destination as! CellViewController
            vc.postId = self.passMe
        }
    }
    
}

