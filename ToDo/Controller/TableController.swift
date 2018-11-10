//
//  ViewController.swift
//  ToDo
//
//  Created by Karol Struniawski on 04/11/2018.
//  Copyright © 2018 Karol Struniawski. All rights reserved.
//

import UIKit

class TableController: UITableViewController{

    var toDoArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
                self.toDoArray.append(Item(name : alert.textFields![0].text!))
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
            let data = try PropertyListEncoder().encode(toDoArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error endocing item array")
        }
    }
    
    func loadItems(){
        do{
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            try self.toDoArray = decoder.decode([Item].self, from: data)
        }catch{
            print("Error loading local data!")
        }
    }
}

