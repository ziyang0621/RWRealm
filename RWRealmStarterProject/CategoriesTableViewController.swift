//
//  CategoriesTableViewController.swift
//  RWRealmStarterProject
//
//  Created by Bill Kastanakis on 8/6/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {

    var categories = Realm().objects(Category)
    var selectedCategory: Category!
    
  // MARK: - View Lifecycle
    
    func populateDefaultCategories() {
        
        if categories.count == 0 {
            let realm = Realm()
            
            let defaultCategories = ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids"]
            for category in defaultCategories {
                let newCategory = Category()
                newCategory.name = category
                realm.write {
                    realm.add(newCategory)
                }
            }
            
            categories = Realm().objects(Category)
        }
    }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    println(Realm().path)
    populateDefaultCategories()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Int(categories.count)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! UITableViewCell
    
    let category = categories[indexPath.row]
    cell.textLabel!.text = category.name

    return cell
  }

  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath {
    selectedCategory = categories[indexPath.row]
    return indexPath
  }
  
}
