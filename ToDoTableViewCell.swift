//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Seshu Adunuthula on 1/15/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//
import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var ToDoText: UILabel!
    @IBOutlet weak var CreateDate: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        let recordName = sender.accessibilityIdentifier
        
        print ("Deleting Record \(recordName!)")
        let recordDict:[String: String] = ["recordName": recordName!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecordDeleted"),
                                        object: nil, userInfo: recordDict)
    }
    
    func set(todoText: String, createDate: String, recordName: String) {
        self.ToDoText.text = todoText
        self.CreateDate.text = createDate
        self.doneButton.accessibilityIdentifier = recordName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
