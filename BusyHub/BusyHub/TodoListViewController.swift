//
//  ViewController.swift
//  BusyHub
//
//  Created by Emanuel Covaci on 08/03/2019.
//  Copyright © 2019 Emanuel Covaci. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemsArray = ["Work", "School", "Jogging"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListItems") as? [String]{
            itemsArray = items
        }
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        cell.textLabel?.text = itemsArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemsArray[indexPath.row])
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new BusyHud item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            print(textField.text!)
            self.itemsArray.append(textField.text!)
            self.defaults.set(self.itemsArray, forKey: "ToDoListItems")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

