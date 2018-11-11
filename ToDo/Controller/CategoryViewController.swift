//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Karol Struniawski on 11/11/2018.
//  Copyright © 2018 Karol Struniawski. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    // MARK: - Add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Add category", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Write category name"
        }
        let action = UIAlertAction.init(title: "Add", style: .default) { (action) in
            if alert.textFields![0].text!.count > 1{
                let newCategory = Category(context: self.context)
                newCategory.name = alert.textFields![0].text
                self.categoriesArray.append(newCategory)
                self.save()
            }
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableController
        let indexPath = tableView.indexPathForSelectedRow!.row
        destinationVC.selectedCategory = categoriesArray[indexPath]
    }
    
    // MARK: - Data Manipulation
    func save(){
        do{
            try context.save()
        }catch{
            print("Error saving data!")
        }
        self.tableView.reloadData()
    }
    
    func load() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            try categoriesArray = context.fetch(request)
        } catch {
            print("Unable to load data!")
        }
        
    }
    
}
