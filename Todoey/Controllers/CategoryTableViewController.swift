//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Joshua Veal on 4/18/19.
//  Copyright © 2019 Joshua Veal. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm: Realm = try! Realm()
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: TodoListViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField: UITextField = UITextField()
        
        let alert: UIAlertController = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != nil {
                
                let newCategory: Category = Category()
                
                newCategory.name = textField.text!
                
                self.save(category: newCategory)
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error writing to realm: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
    
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }

}
