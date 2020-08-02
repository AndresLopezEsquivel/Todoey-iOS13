//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
import UIKit

class ToDoListViewController: UITableViewController {
    
    var listElements = [Item]()
    
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        do
        {
            try loadItems()
        }
        catch is ErrorsGroup
        {
            print("An error from ErrorsGroup occurred")
        }
        catch
        {
            print("An unexpected error occurred: \(error)")
        }
    }

//MARK: -DATASOURCE
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listElements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellName, for: indexPath)
        
        cell.textLabel?.text = listElements[indexPath.row].title
        
        cell.accessoryType = listElements[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
//MARK: -DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(listElements[indexPath.row])
        
        //Code to verify if the cell selected needs a checkmark to be added or removed.
        
        /*if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }*/
        
        listElements[indexPath.row].done = !listElements[indexPath.row].done
        
        do
        {
            try encodeData()
        }
        catch
        {
            print("Error occurred: \(error)")
        }
        
        tableView.reloadData()
        
        //Method to disabled the highlighting effect in each cell selected.
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
                self.listElements.append(Item(title: userTask, done: false))
                
                do
                {
                    try self.encodeData()
                }
                catch
                {
                    print("An error occurred: \(error)")
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
    
    func encodeData() throws
    {
        let encoder = PropertyListEncoder()
        
        let data = try encoder.encode(self.listElements)
        
        if let safeDataPath = self.dataPath
        {
            try data.write(to: safeDataPath)
        }
        else
        {
            throw ErrorsGroup.MissingDataPath
        }
    }
    
    func loadItems() throws
    {
        guard let safeDataPath = dataPath else
        {
            throw ErrorsGroup.MissingDataPath
        }
        
        guard let data = try? Data(contentsOf: safeDataPath) else
        {
            throw ErrorsGroup.DataNotFound
        }
        
        let decoder = PropertyListDecoder()
        
        listElements = try decoder.decode([Item].self, from: data)
    }

}
