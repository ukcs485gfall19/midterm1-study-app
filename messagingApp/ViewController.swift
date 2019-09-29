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
    
    var postData = [String]()
    var passMe = ""
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //set the firebase reference
        ref = Database.database().reference()
        
        //retrieve posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post{
                self.postData.append(actualPost)
                self.tableView.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        passMe = postData[indexPath.row]
        performSegue(withIdentifier: "segue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue" {
        var vc = segue.destination as! CellViewController
            vc.finalName = self.passMe
        }
    }
    
}

