//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Andres Lopez Esquivel on 04/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var listCategories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return listCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellCategory, for: indexPath)
        
        cell.textLabel?.text = listCategories[indexPath.row].name
        
        return cell
    }
    
    //MARK: - DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: K.segueToItems, sender: self)
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
                let newCategory = Category(context: self.context)
                
                newCategory.name = categoryName
                
                self.listCategories.append(newCategory)
                
                do
                {
                    try self.saveData()
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
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()) throws
    {
        listCategories = try context.fetch(request)
        
        tableView.reloadData()
    }
    
    func saveData() throws
    {
        try context.save()
        
        tableView.reloadData()
    }
}

//MARK: - SEARCH BAR

extension CategoryTableViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        if let dataSearched = searchBar.text
        {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", dataSearched)
            
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            do
            {
                try loadData(with: request)
            }
            catch
            {
                print("An error occurred while loading data")
                print(error)
            }
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
