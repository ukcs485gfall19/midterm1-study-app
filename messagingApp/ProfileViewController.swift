//
//  ProfileViewController.swift
//  messagingApp
//
//  Created by Joshua Steinbach on 11/3/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var UIDLabel: UILabel!
    @IBOutlet weak var userEventsTableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton!
    var ref:DatabaseReference?
    var postIDs = [String]()
    var titleIDs = [String]()
    var descIDs = [String]()
    var userName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registeruserEventsTableViewCells()
        
        //sets your name
        nameLabel.text = userName
        
        userEventsTableView.delegate = self
        userEventsTableView.dataSource = self
        
        //set the firebase reference
        ref = Database.database().reference()
        //gets rid of weird empty space at top of grouped cell view
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        userEventsTableView.tableHeaderView = UIView(frame: frame)
        //sets the height to be automatic
        userEventsTableView.rowHeight = UITableView.automaticDimension
        userEventsTableView.estimatedRowHeight = 600
        
        //print(postIDs)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        ref = Database.database().reference()
        for postId in postIDs{
            ref?.child("Posts").child(postId).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                
                //setting body
                let body = value?["Body"] as? String ?? "Body Placeholder"
                self.descIDs.append(body)
                
                //setting title
                let title = value?["Title"] as? String ?? "Title Placeholder"
                self.titleIDs.append(title)
                self.userEventsTableView.reloadData()
            })
        }
        //print(titleIDs)
        
    }
    func registeruserEventsTableViewCells(){
        let viewFieldCell = UINib(nibName:"customViewCell",bundle:nil)
        //print(postIDs)
        self.userEventsTableView.register(viewFieldCell, forCellReuseIdentifier: "customViewCell")
    }
    @IBAction func logout(sender:Any){
        performSegue(withIdentifier: "signoutSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let vc = segue.destination as! ViewController
            vc.userID = ""
            vc.navItem.title = "Posts"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customViewCell") as? customViewCell
        cell?.header.text = titleIDs[indexPath.row]
        cell?.footer.text = descIDs[indexPath.row]
        return cell!
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
