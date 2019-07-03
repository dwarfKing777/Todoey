//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Geetesh Vaigankar on 02/07/19.
//  Copyright © 2019 RubikEdge. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //var newItem = Item()
        let newItem = categoryArray[indexPath.row]
        
        cell.textLabel?.text = newItem.name
        
//        cell.accessoryType = newItem.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    
    //MARK - Model Data Manupulation Methods
    
    func saveData() {
        
        do {
            try context.save()
        }
        catch {
            print ("Error saving data! \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    // Load items from sqlite database
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error retrieving data from sqlite \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    //MARK - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newItem1 = Category(context: self.context)
            newItem1.name = textField.text!
//            newItem1.done = false
            self.categoryArray.append(newItem1)
            
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category here"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
