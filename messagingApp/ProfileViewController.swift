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
    
    var passMe:String = ""
    var ref:DatabaseReference?
    var postIDs = [String]()
    var user = User()
    var model = postModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registeruserEventsTableViewCells()
        
        //sets your name
        nameLabel.text = user.userName
        UIDLabel.text = user.userID
        
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
        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        postIDs = user.savedPosts
        
    }
    func registeruserEventsTableViewCells(){
        let viewFieldCell = UINib(nibName:"customViewCell",bundle:nil)
        self.userEventsTableView.register(viewFieldCell, forCellReuseIdentifier: "customViewCell")
    }
    @IBAction func logout(sender:Any){
        performSegue(withIdentifier: "signoutSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! CellViewController
            vc.postId = self.passMe //passing id to cell view
        }
        if segue.identifier == "signoutSegue"{
            let vc = segue.destination as! ViewController
            vc.user = User()
            vc.navItem.title = "Posts"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.savedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customViewCell") as? customViewCell
        let index = model.postIDS.firstIndex(of:user.savedPosts[indexPath.row])!
        cell?.post = model.posts[index]
        cell?.user = user
        cell?.load()
        //cell?.switchView.isHidden = true
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passMe = user.savedPosts[indexPath.row]
        
        performSegue(withIdentifier: "segue", sender: self)
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
