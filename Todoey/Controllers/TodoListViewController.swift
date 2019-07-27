//
//  ViewController.swift
//  Todoey
//
//  Created by Joshua Veal on 4/15/19.
//  Copyright © 2019 Joshua Veal. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm: Realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert: UIAlertController = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != nil {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            
                            currentCategory.items.append(newItem)
                            
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Error writing to realm: \(error)")
                    }
                }

            }

        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
                
        if let item: Item = todoItems?[indexPath.row] {
            
            cell.accessoryType = item.done ? .checkmark : .none
            cell.textLabel?.text = item.title
            
        } else {
            print("0 items")
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        
        
        return cell
    }

    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating realm item: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
 
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.count == 0 {
            loadItems()
        } else {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

            todoItems = todoItems?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
    }
    
}
