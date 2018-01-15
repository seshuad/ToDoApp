//
//  ViewController.swift
//  ToDoApp
//
//  Created by Seshu Adunuthula on 1/6/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet var itemTextField: UITextField?
    @IBOutlet var tableView: UITableView?
    
    let toDoList = ToDoList();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView?.dataSource = toDoList
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

}

