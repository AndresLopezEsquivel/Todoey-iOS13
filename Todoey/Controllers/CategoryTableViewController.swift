//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Andres Lopez Esquivel on 04/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var realm = try! Realm()
    
    var listCategories : Results<Category>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        do
        {
            try loadData()
        }
        catch
        {
            print("Data couldn't be loaded")
            print(error)
        }
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listCategories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellCategory, for: indexPath)
        
        cell.textLabel?.text = listCategories?[indexPath.row].name ?? "There are not categories available"
        
        return cell
    }
    
    //MARK: - DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: K.segueToItems, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let toDoListVC = segue.destination as! ToDoListViewController
        
        if let indexPathRow = tableView.indexPathForSelectedRow?.row
        {
            toDoListVC.selectedCategory = listCategories?[indexPathRow]
        }
        else
        {
            print("Segue Preparation Fails")
        }
        
    }
    
    //MARK: - ADD CATEGORY PROCESSES
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "Hey! It seems that you want to add a new category, let's do it.", preferredStyle: .alert)
        
        alert.addTextField
        {
            alertTextField in
            
            alertTextField.placeholder = "Write the name of the new category"
            
            textField = alertTextField
        }
        
        let actionAlert = UIAlertAction(title: "Add Category", style: .default)
        {
            action in
            
            if let categoryName = textField.text
            {
                let newCategory = Category()
                
                newCategory.name = categoryName
                
                do
                {
                    try self.saveData(category: newCategory)
                }
                catch
                {
                    print("An error occurred while saving data.")
                    print(error)
                }
            }
            else
            {
                print("The user didn't write any category")
            }
        }
        
        alert.addAction(actionAlert)
        
        present(alert,animated: true)
    }
    
}

//MARK: - DATA PROCESSES

extension CategoryTableViewController
{
    func loadData() throws
    {
        listCategories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func saveData(category data : Category) throws
    {
        try realm.write
        {
            realm.add(data)
        }
        
        tableView.reloadData()
    }
}

//MARK: - SEARCH BAR

extension CategoryTableViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        if let dataSearched = searchBar.text
        {
            listCategories = listCategories?.filter(NSPredicate(format: "name CONTAINS[cd] %@", dataSearched)).sorted(byKeyPath: "name", ascending: true)
            
            tableView.reloadData()
        }
        else
        {
            print("There isn't data to search")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text!.isEmpty
        {
            do
            {
                try loadData()
                
                DispatchQueue.main.async
                {
                    searchBar.resignFirstResponder()
                }
            }
            catch
            {
                print("An error ocurred while loading data")
                print(error)
            }
        }
    }
}
