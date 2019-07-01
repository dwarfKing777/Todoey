//
//  ViewController.swift
//  Todoey
//
//  Created by Geetesh Vaigankar on 30/06/19.
//  Copyright © 2019 RubikEdge. All rights reserved.
//

import UIKit

class TodoeyTableViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    let rowNumber = 0
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

//        print(dataFilePath)
        
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
        loadItems()
        
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
        
        self.saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem1 = Item()
            newItem1.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print ("Error occured! \(error)")
        }
        tableView.reloadData()
        
    }

    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding the data. \(error)")
            }
        }
    }
    
}
