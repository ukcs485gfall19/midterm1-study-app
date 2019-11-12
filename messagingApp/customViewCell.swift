//
//  customViewCell.swift
//  messagingApp
//
//  Created by Kilgore on 10/29/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
//

import UIKit

class customViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var footer: UILabel!
    let switchView = UISwitch(frame: .zero)
    
    var objectId:String=""
    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.setOn(false, animated: true)
        switchView.addTarget(self, action: #selector(switchchanged), for: .valueChanged)
        //switchView.tag = indexPath.row // for detect which row switch Changed
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func switchchanged(_ sender: UISwitch!){
        if(sender.isOn){
            
        }
        else{
            
        }
    }
    
    
}
