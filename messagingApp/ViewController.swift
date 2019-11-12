//
//  ViewController.swift
//  messagingApp
//
//  Created by Joshua Steinbach on 9/12/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
// fix commit

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    var userID:String!
    var filteredData = [String]()
    var filteredIndex = [Int]()
    var titleData = [String]()
    var descData = [String]()
    var editingBar:Bool = false
    var refresher:UIRefreshControl!
    var loaded = true
    //our model
    var model = postModel()
    
    //login variables
    @IBOutlet weak var userButton: UIBarButtonItem!
    var loggedIn = false
    
    var searchController: UISearchController!
    
    var postData = [String]() //holds a list of database post keys
    var passMe = "" //holds the unique database post key to be passed to the cell view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navItem.title = "Posts"
        self.registerTableViewCells()
        
        //just for simplicity
        userButton.tintColor = UIColor.systemBlue
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //adds the segue buttons
        userButton.action = #selector(login)
        userButton.target = self
        
        //sets the refresher
        configureRefreshControl()
        tableView.refreshControl = refresher
        
        //retrieve posts and listen for changes
        model.loadDataWithView(view: self)
        
        //gets rid of weird empty space at top of grouped cell view
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        //sets the height to be automatic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        //search bar stuff
        self.searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Posts"
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //search bar functions
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            editingBar = true
            filteredData = []
            filteredIndex = []
            var indexNum = 0;
            for index in model.posts{
                let indexString:String = index.title
                if(indexString.lowercased().contains(searchText.lowercased())){
                    filteredData.append(indexString)
                    filteredIndex.append(indexNum)
                }
                indexNum+=1
            }
            if(searchText.count==0){
                editingBar = false
            }
            tableView.reloadData()
        }
    }
    
    //now i can register my custom cells
    func registerTableViewCells(){
        let viewFieldCell = UINib(nibName:"customViewCell",bundle:nil)
        self.tableView.register(viewFieldCell, forCellReuseIdentifier: "customViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(editingBar){
            return filteredData.count
        }
        else{
            return model.posts.count
        }
    }
    
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       refresher = UIRefreshControl()
       refresher.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
        
    @objc func handleRefreshControl() {
        if(!editingBar){
            tableView.reloadData()
        }
        DispatchQueue.main.async {
           self.refresher.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //kilgore change, changed the cell so it loads my custom class and also sets a description blurb under the title
        let cell = tableView.dequeueReusableCell(withIdentifier: "customViewCell") as? customViewCell
        // ignore this stuff
        
        //cell?.objectId = postData[indexPath.row]

         
        //print(switches.count)
        if(editingBar){
            cell?.header.text = model.posts[filteredIndex[indexPath.row]].title
            cell?.footer.text = model.posts[filteredIndex[indexPath.row]].desc
        }
        else{
            cell?.header.text = model.posts[indexPath.row].title
            cell?.footer.text = model.posts[indexPath.row].desc
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(editingBar){
            passMe = model.posts[filteredIndex[indexPath.row]].id
        }
        else{
            passMe = model.posts[indexPath.row].id
        }
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    @IBAction func login(){
        if(!loggedIn){
            performSegue(withIdentifier: "userSegue", sender: self)
        }
        else{
            performSegue(withIdentifier: "userPage", sender: self)
        }
    }
    @IBAction func signin(_ unwindSegue: UIStoryboardSegue) {
        userButton.tintColor = UIColor.black
        loggedIn = true
    }
    @IBAction func signout(_ unwindSegue: UIStoryboardSegue) {
        userButton.tintColor = UIColor.systemBlue
        loggedIn = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue" {
            let vc = segue.destination as! CellViewController
            vc.postId = self.passMe //passing id to cell view
        }
        if segue.identifier == "userPage"{
            let vc = segue.destination as! ProfileViewController
            //vc.postIDs = starredPosts
            vc.userName = userID
        }
    }
    
    
}

