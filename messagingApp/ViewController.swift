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

    @IBOutlet weak var userButton: UIBarButtonItem!
    var searchController: UISearchController!
    
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
        
        //sets the refresher
        configureRefreshControl()
        tableView.refreshControl = refresher
        
        //retrieve posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let postId = snapshot.key
            self.postData.append(postId)
            let value = snapshot.value as? NSDictionary
            self.titleData.append(value?["Title"] as? String ?? "Title Placeholder")
            self.descData.append(value?["Body"] as? String ?? "Body Placeholder")
            self.filteredData = self.titleData
            self.filteredIndex.append(-1)
            self.tableView.reloadData()
        })
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
            for indexString in titleData{
                if(indexString.lowercased().contains(searchText.lowercased())){
                    filteredData.append(indexString)
                    filteredIndex.append(titleData.firstIndex(of:indexString) ?? 0)
                }
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
            return postData.count
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
        if(editingBar){
            cell?.header.text = titleData[filteredIndex[indexPath.row]]
            cell?.footer.text = descData[filteredIndex[indexPath.row]]
        }
        else{
            cell?.header.text = titleData[indexPath.row]
            cell?.footer.text = descData[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(editingBar){
            passMe = postData[filteredIndex[indexPath.row]]
        }
        else{
            passMe = postData[indexPath.row]
        }
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        userButton.isEnabled = false
        navigationItem.leftBarButtonItem = nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue" {
        let vc = segue.destination as! CellViewController
            vc.postId = self.passMe //passing id to cell view
        }
    }
    
    
}

