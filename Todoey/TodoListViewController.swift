//
//  ViewController.swift
//  Todoey
//
//  Created by Alberto Hernandez Testa on 8/25/19.
//  Copyright © 2019 Alberto Hernandez Testa. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath!)        
        loadItems()
       // lee los items del defaults
       //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
       //     itemArray = items
        //}
    }
// MARK - table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
// MARK - table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new items
    
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            // registra el dato en el plist
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
            
        }
            self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding item array, \(error)")
            }
        }
    
    }
}

