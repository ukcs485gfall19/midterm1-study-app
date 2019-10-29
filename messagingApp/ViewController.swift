//
//  ViewController.swift
//  messagingApp
//
//  Created by Joshua Steinbach on 9/12/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
// fix commit

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var postData = [String]() //holds a list of database post keys
    var passMe = "" //holds the unique database post key to be passed to the cell view
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navItem.title = "Posts"
        self.registerTableViewCells()
        
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
        //gets rid of weird empty space at top of grouped cell view
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        //sets the height to be automatic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    //now i can register my custom cells
    func registerTableViewCells(){
        let viewFieldCell = UINib(nibName:"customViewCell",bundle:nil)
        self.tableView.register(viewFieldCell, forCellReuseIdentifier: "customViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //kilgore change, changed the cell so it loads my custom class and also sets a description blurb under the title
        let cell = tableView.dequeueReusableCell(withIdentifier: "customViewCell") as? customViewCell
        
        ref?.child("Posts").child(postData[indexPath.row]).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let title = value?["Title"] as? String ?? "Title Placeholder"
            let body = value?["Body"] as? String ?? "Body Placeholder"
            cell?.header.text = title
            cell?.footer.text = body//this is what actually gets put in the cell
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
            vc.postId = self.passMe //passing id to cell view
        }
    }
    
}

