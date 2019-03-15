//
//  CategoryViewController.swift
//  BusyHub
//
//  Created by Emanuel Covaci on 14/03/2019.
//  Copyright © 2019 Emanuel Covaci. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoriesArray: Results<Category>?


    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        loadCategories()
        tableView.rowHeight = 80.0
    }


    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            print(textField.text!)
            let category = Category()
            category.name = textField.text!
            
            self.save(category: category)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "Not categories added yet!"
        
        cell.delegate = self
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoriesArray?[indexPath.row]
            }
        }
    }
    
    
    
    
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print ("Error saving contex! \(error)")
        }
    }
    
    func loadCategories(){
        
        categoriesArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    

}

extension CategoryViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Delete item")
            if let category = self.categoriesArray?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                    
                }catch{
                    print("Error deleting category, \(error)")
                }
            }
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
}
