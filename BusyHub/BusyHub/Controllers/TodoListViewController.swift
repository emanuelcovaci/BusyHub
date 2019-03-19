//
//  ViewController.swift
//  BusyHub
//
//  Created by Emanuel Covaci on 08/03/2019.
//  Copyright © 2019 Emanuel Covaci. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems: Results<Item>?
   
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.rowHeight = 80.0
         tableView.separatorStyle = .none
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.color else {fatalError()}
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            updateNavBar(withHexCode: FlatSkyBlue().hexValue())
    }
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count + 7)){
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
        }else{
            cell.textLabel?.text = "No items added"
        }
      
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
                
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new BusyHud item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                            let newItem = Item()
                        if(textField.text!.count == 0){
                            return
                        }
                            newItem.title = textField.text!
                            currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("Error saving item \(error)")
                }
            }
            
            self.tableView.reloadData()
            
          
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let item = self.toDoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(item)}
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
}

//MARK: -  Search Bar search button clicked

extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main .async {
                searchBar.resignFirstResponder()
            }
        }

    }

}

