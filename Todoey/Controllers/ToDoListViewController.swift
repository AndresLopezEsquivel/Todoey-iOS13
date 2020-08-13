//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var listElements : Results<Item>?
    
    var realm = try! Realm()
    
    var selectedCategory : Category?
    {
        didSet
        {
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

//MARK: -DATASOURCE
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listElements?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath)
        
        if let item = listElements?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
//MARK: -DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //Code to verify if the cell selected needs a checkmark to be added or removed.
        
        /*if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }*/
        
        //listElements[indexPath.row].done = !listElements[indexPath.row].done
        
        if let item = listElements?[indexPath.row]
        {
            do
            {
                try realm.write
                {
                    item.done = !item.done
                }
            }
            catch
            {
                print("There was an error while trying to update data")
                print(error)
            }
        }
        else
        {
            print("There is no item")
        }
        
        tableView.reloadData()
        
        //Method to disable the highlighting effect in each cell selected.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: -ALERT
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textFieldAlert = UITextField()
        //Creating UIAlertController
        let alert = UIAlertController(title: "Hey! It seems you want to add a new task. Let's do it.", message: nil, preferredStyle: .alert)
        //Creating an UIAlertAction variable to stablish the actions
        //that can be made by the alert created previously.
        let actionAlert = UIAlertAction(title: "Add new task", style: .default)
        {
            action in
            print("Hi! Good job. You've created a task.")
            
            if let userTask = textFieldAlert.text
            {
                
                if let currentCategory = self.selectedCategory
                {
                    let newItem = Item()
                    
                    newItem.title = userTask
                    
                    newItem.done = false
                    
                    newItem.dateCreated = Date()
                    
                    do
                    {
                        try self.realm.write
                        {
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch
                    {
                        print("An error occurred: \(error)")
                    }
                }
                else
                {
                    print("There is no category selected")
                }
                
                self.tableView.reloadData()
 
            }
            else
            {
                print("An error occurred")
            }
            
        }
        
        //The action created needs to be added to the alert.
        alert.addAction(actionAlert)
        
        //In order to receive data from the user, the creation of a
        //UITextField inside the alert is necessary. Many different
        //elements can be added to the alert, such as UITextFields.
        //Let's code it. :)
        
        //Warning: The method is implemented only for adding a UITextField
        //to the alert, so, we cannot know the text written by the user
        //and kept by the UITextField yet.
        
        alert.addTextField
        {
            textField in
            textField.placeholder = "What's the new task?"
            textFieldAlert = textField
        }
        
        //The alert, along with its action, needs to be presented when called.
        present(alert, animated: true, completion: nil)
    }
    
    func loadData()
    {
        
        listElements = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }

}

//MARK: - UISearchBarDelegate
extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if let dataSearched = searchBar.text
        {
            listElements = listElements?.filter(NSPredicate(format: "title CONTAINS[cd] %@", dataSearched)).sorted(byKeyPath: "dateCreated", ascending: true)
            
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
            loadData()
            
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }
        }
    }
}
