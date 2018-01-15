//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Seshu Adunuthula on 1/8/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import UIKit
import CloudKit


class ToDoList: NSObject {
 
    private var items:[String] = []
    let container: CKContainer = CKContainer.default()
    let formatter = DateFormatter()
    
    
    func add(_ todo: String) {
        self.formatter.dateFormat = "MM/dd"
        let date = Date()
        let item = self.formatter.string(from: date) + " " + todo
        items.append(item)
    
        saveItem(todo, date)
    }
    
    func saveItem(_ todo: String, _ date: Date) {
        print("Saving to Cloud Container")
        
        let record = CKRecord(recordType: "ToDoRecord")
        record["ToDo"] = todo as CKRecordValue
        record["CreateDate"] = date as CKRecordValue
        record["Status"] = 0 as CKRecordValue
        
        let privateDB = container.privateCloudDatabase
        privateDB.save(record) { (record, error) -> Void in
            guard let record = record else {
                print("Error saving record: ", error)
                return
            }
            print("Successfully saved record: ", record)
        }
        
    }
    
    
    func loadItems() {
        print ("Loading items")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ToDoRecord", predicate: predicate)
        var queryResults:[CKRecord] = []
        let group = DispatchGroup()
        group.enter()

        
        let privateDB = container.privateCloudDatabase
        privateDB.perform(query, inZoneWith: nil) {results, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Refresh: \(error!)")
                }
                return
            }
            queryResults = results!
            print ("results (in handler) \(queryResults.count)")
            group.leave()
        }
        
        group.wait()
        print ("results \(queryResults.count)")

        for record in queryResults {
            let todo = record.object(forKey: "ToDo") as! String
            let createDate = record.object(forKey: "CreateDate") as! Date
            self.formatter.dateFormat = "MM/dd"
            let item = self.formatter.string(from:createDate) + " " + todo
            self.items.append(item)
        }
        
    }
    
    override init() {
        super.init()
        loadItems()
    }

}

extension ToDoList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel!.text = item
        
        return cell
    }
}
