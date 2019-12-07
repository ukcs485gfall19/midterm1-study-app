//
//  CellViewController.swift
//  messagingApp
//
//  Created by Kye Miller on 9/28/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
// fix commit

import UIKit
import FirebaseDatabase
import EventKit

//var finalName = ""
class CellViewController: UIViewController {
    
    @IBOutlet weak var test: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var ref:DatabaseReference?
    var postId = "" // INITIALIZE BLANK OBJECT FOR SEGUE
    var model = postModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        //noting small change i made here, added spaces to the beginning of each text field to make them look better
        //setting body
        let value = model.posts[model.postIDS.firstIndex(of: postId)!]
        self.test.text = value.desc
        
        //setting title
        self.titleLabel.text = "  " + value.title
        
        //setting course
        self.courseLabel.text = "  Course: " + value.prefix + " " + value.number
        
        //setting date/location
        self.locLabel.text = "  Location: " + value.location
        self.dateLabel.text = "  " + value.date + "-" + value.endTime.dropFirst(16)
        

        let labelHolster:[UILabel] = [self.titleLabel,self.courseLabel,self.locLabel,self.dateLabel]
        //setting some nice boundaries
        for currLabel in labelHolster{
            currLabel.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
            currLabel.layer.borderWidth = 0.5
        }
    }
    
    @IBAction func calendarSync(_ sender: Any) {
        
        let eventStore:EKEventStore = EKEventStore()
        ref?.child("Posts").child(postId).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let dateFormatter = DateFormatter()
            let startDate = value?["Date"] as! String
            let endDate = value?["endTime"] as! String
            
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale(identifier: "en_US")
            
            eventStore.requestAccess(to: .event, completion: {(granted, error) in
                
                
                if (granted) && (error == nil)
                {
                    print("granted \(granted)")
                    print("error \(error)")
                    
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                    event.title = value?["Title"] as? String
                    event.startDate = dateFormatter.date(from: startDate)
                    event.endDate = dateFormatter.date(from: endDate)
                    event.notes = value?["Location"] as? String
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do{
                        
                        let CALENDAR_DEFAULTS_KEY = "\(String(describing: event.title))\(startDate.description)_ADDED_TO_CALENDAR"
                        let eventExists = UserDefaults.standard.bool(forKey:CALENDAR_DEFAULTS_KEY)
                        if eventExists{
                            self.showDuplicateEvent()
                        }
                        else {
                        try eventStore.save(event, span: .thisEvent)
                        self.showEventAdded()
                        }
                    }catch let error as NSError{
                        print(error)
                    }
                    
                    
                }
                
                
            })
            
        })
    }
    
    func showEventAdded() { DispatchQueue.main.async {
        let alert = UIAlertController(title: "Event Added To Calendar", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        //  guard let url = URL(string: "calshow://") else { return }
        //  UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    }
    
    func showDuplicateEvent() { DispatchQueue.main.async {
        let alert = UIAlertController(title: "Event Already Added to Calendar", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        //  guard let url = URL(string: "calshow://") else { return }
        //  UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        }
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
