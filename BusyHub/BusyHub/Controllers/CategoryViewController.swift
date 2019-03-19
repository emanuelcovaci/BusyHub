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



class CategoryViewController: SwipeTableViewController {
    
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
            if(textField.text!.count == 0){
                return
            }
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "Not categories added yet!"
        
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
    
    //MARK: - Delete Data From list
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let category = self.categoriesArray?[indexPath.row]{
            do{
                 try self.realm.write {
                 self.realm.delete(category)}
                }catch{
                    print("Error deleting category, \(error)")
                }
         }
       }
    

}


