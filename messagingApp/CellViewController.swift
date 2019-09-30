//
//  CellViewController.swift
//  messagingApp
//
//  Created by Kye Miller on 9/28/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit

//var finalName = ""
class CellViewController: UIViewController {
    
    @IBOutlet weak var test: UITextView!
    
    var finalName = "" // INITIALIZE BLANK OBJECT FOR SEGUE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        test.text = finalName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
