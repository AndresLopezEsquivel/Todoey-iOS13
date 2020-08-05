//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Andres Lopez Esquivel on 04/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var listCategories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategories.count
    }

    //MARK: - ADD CATEGORY PROCESSES
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Add a new category", message: "Hey! It seems that you want to add a new category, let's do it.", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: nil, style: .default, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
    }
    
}
