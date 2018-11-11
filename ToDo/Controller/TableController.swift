//
//  ViewController.swift
//  ToDo
//
//  Created by Karol Struniawski on 04/11/2018.
//  Copyright © 2018 Karol Struniawski. All rights reserved.
//

import UIKit
import CoreData

class TableController: UITableViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    var toDoArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row].name

        if self.toDoArray[indexPath.row].done == false {
            cell.accessoryType = .none
        }else{
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.toDoArray[indexPath.row].done = !self.toDoArray[indexPath.row].done
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new element", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if alert.textFields![0].text!.count > 1{
                let newItem = Item(context: self.context)
                newItem.name = alert.textFields![0].text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.toDoArray.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation
    func saveItems(){
        do{
            try context.save()
        } catch{
        }
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),using predicate : NSPredicate? = nil){
        let predicateCategory = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCategory, additionalPredicate])
        }else{
            request.predicate = predicateCategory
        }
        do{
            try self.toDoArray = context.fetch(request)
        }catch{
            print("Error fetching data")
        }
        tableView.reloadData()
    }
}

extension TableController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        let sortDesciptor1 = NSSortDescriptor(key: "name", ascending: true)
        let sortDesciptor2 = NSSortDescriptor(key: "done", ascending: false)
        request.sortDescriptors = [sortDesciptor2, sortDesciptor1]
        
        loadItems(with: request, using: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
