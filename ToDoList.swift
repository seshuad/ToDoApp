//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Seshu Adunuthula on 1/8/18.
//  Copyright © 2018 Seshu Adunuthula. All rights reserved.
//

import UIKit
import CloudKit

struct ToDoItem {
    var recordName: String
    var todoText: String
    var createDate: Date
    var updateDate: Date
    var Status: Int
}

class ToDoList: NSObject {
 
    var items:[ToDoItem] = []
    let container: CKContainer = CKContainer.default()
    let formatter = DateFormatter()
    
    
    func add(_ todo: String) {
        let date = Date()
        let recordName = UUID().uuidString
        let todoItem = ToDoItem(recordName: recordName, todoText: todo, createDate: date, updateDate: date, Status: 0)
        
        items.append(todoItem)
        saveItem(todoText: todo, createDate: date, recordName: recordName)
    }
    
    func saveItem(todoText: String, createDate: Date, recordName: String) {
        print("Saving to Cloud Container")
        
        let record = CKRecord(recordType: "ToDoRecord", recordID: CKRecordID(recordName: recordName))
        
        record["ToDo"] = todoText as CKRecordValue
        record["CreateDate"] = createDate as CKRecordValue
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
    
    func deleteItem(_ recordName: String) {
        print ("Deleting Record \(recordName)")
        
        let privateDB = container.privateCloudDatabase
        let recordID = CKRecordID(recordName: recordName)
        privateDB.delete(withRecordID: recordID) { (recordID, error) -> Void in
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Refresh: \(error!)")
                }
                return
            }
        }
        
        items = items.filter {$0.recordName != recordName}
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
            let date = record.object(forKey: "CreateDate") as! Date
            self.formatter.dateFormat = "MM/dd"
  
            let todoItem = ToDoItem(recordName:record.recordID.recordName, todoText: todo, createDate: date, updateDate: date, Status: 0)
            self.items.append(todoItem)
        }
        
    }
    
    override init() {
        super.init()
        loadItems()
    }
}

