//
//  ViewController.swift
//  Todoey
//
//  Created by Geetesh Vaigankar on 30/06/19.
//  Copyright © 2019 RubikEdge. All rights reserved.
//

import UIKit
import CoreData

class TodoeyTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    let rowNumber = 0
    let defaults = UserDefaults.standard
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        let newItem = Item()
//        newItem.title = "asd"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "hdskjfhdskfhd"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "asd djskhfskjfhkj ksdhfkjds fjkdsf k"
//        itemArray.append(newItem3)
//
//        let newItem4 = Item()
//        newItem4.title = "asd a jdhskj fhk"
//        itemArray.append(newItem4)
        
        //Call to load saved items
//        loadItems()
        
//        if let itemsLoad = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = itemsLoad
//        }
        
        
        // Do any additional setup after loading the view.
    }

    
    //MARK: - TableView DataSource Methods

    //TODO: Declare cellForRowAtIndexPath here:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTableView", for: indexPath)
        
        //var newItem = Item()
        let newItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = newItem.title
        
        cell.accessoryType = newItem.done ? .checkmark : .none
        
//        if newItem.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

     //MARK: - TableView Delegate Methods
    
    //TODO: Declare didSelectRowAt here:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("row data: \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //Remove or delete from sqlite database
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem1 = Item(context: self.context)
            newItem1.title = textField.text!
            newItem1.done = false
            newItem1.parentCategory = self.selectedCategory
            self.itemArray.append(newItem1)
            
            self.saveData()
//            self.defaults.set(newItem1.title, forKey: "ToDoListArray")
//            self.defaults.set(newItem1.done, forKey: "ToDoListArray")
//            self.defaults.set(newItem1, forKey: "ToDoListArray")
//            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item here"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
   
    //MARK - Model Data Manupulation
    func saveData() {
        
        do {
            try context.save()
        }
        catch {
            print ("Error saving data! \(error)")
                }
        
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        }
//        catch {
//            print ("Error occured! \(error)")
//        }
        
        
        tableView.reloadData()
        
    }

    // Load items from sqlite database
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error retrieving data from sqlite \(error)")
        }
        tableView.reloadData()
    }
}


extension TodoeyTableViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
//        do {
//            itemArray = try context.fetch(request)
//        }
//        catch {
//            print("Error retrieving data from sqlite \(error)")
//        }
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}
