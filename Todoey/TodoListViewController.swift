//
//  ViewController.swift
//  Todoey
//
//  Created by Alberto Hernandez Testa on 8/25/19.
//  Copyright © 2019 Alberto Hernandez Testa. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        // este codigo se ejecuta en automatico al asignarse la category (cortesia de swift didset)
        // la categoria se asigna al ser llamada este viewcontroller desde el category controller, al llamar al seguey
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadItems(), ya no es necesario por didSet
       // lee los items del defaults
    }
// MARK - table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }

        return cell
    }
    
// MARK - table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {

                item.done = !item.done
            }
            } catch {
                print("Error saving done status! \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new items
    
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    func loadItems()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    

}

// MARK: - Search Bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // como voy a afectar la UI, lo hago en el main
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }

        }
    }
}
