//
//  ViewController.swift
//  ToDoApp
//
//  Created by Seshu Adunuthula on 1/6/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
   
    @IBOutlet var itemTextField: UITextField?
    @IBOutlet var tableView: UITableView?
    
    let toDoList = ToDoList();
    
    @objc func deleteButtonPressed(_ notification: Notification) {
        let recordName = notification.userInfo?["recordName"] as? String
        toDoList.deleteItem(recordName!)
        tableView?.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let todo = itemTextField?.text else {
            return
        }
        
        toDoList.add(todo)
        tableView?.reloadData()        
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = toDoList.items[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: item.createDate)
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ToDoTableViewCell
        
        cell.set(todoText:item.todoText, createDate:date, recordName: item.recordName)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tableView?.register(ToDoTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.deleteButtonPressed(_:)),
                                               name: NSNotification.Name(rawValue: "RecordDeleted"), object: nil)
    
        tableView?.dataSource = self
        tableView?.reloadData()
    }
}


