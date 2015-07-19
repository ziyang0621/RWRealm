//
//  LogViewController.swift
//  RWRealmStarterProject
//
//  Created by Bill Kastanakis on 8/7/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class LogViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
  
    var specimens = Realm().objects(Specimen).sorted("name", ascending: true)
    var searchResults = Realm().objects(Specimen) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  var searchController : UISearchController!
    
    func deleteRowAtIndexPath(indexPath: NSIndexPath) {
        let realm = Realm()
        let objectToDelete = specimens[indexPath.row]
        realm.write() {
            realm.delete(objectToDelete)
        }
        
        specimens = Realm().objects(Specimen).sorted("name", ascending: true)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func filterResultsWithSearchingString(searchString: String) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString)
        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        switch scopeIndex {
        case 0:
            searchResults = Realm().objects(Specimen).filter(predicate).sorted("name", ascending: true)
        case 1:
            searchResults = Realm().objects(Specimen).filter(predicate).sorted("distance", ascending: true)
        case 2:
            searchResults = Realm().objects(Specimen).filter(predicate).sorted("created", ascending: true)
        default:
            searchResults = Realm().objects(Specimen).filter(predicate)
        }
    }
  
  // MARK: - SearchBar Delegate
  // You can use objectsWhere but let's introduce predicates! :]
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchString = searchController.searchBar.text
        
    let searchResultsController = searchController.searchResultsController as! UITableViewController
    searchResultsController.tableView.reloadData()
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var searchResultsController = UITableViewController(style: .Plain) as UITableViewController
    searchResultsController.tableView.delegate = self
    searchResultsController.tableView.dataSource = self
    searchResultsController.tableView.rowHeight = 63
    searchResultsController.tableView.registerClass(LogCell.self, forCellReuseIdentifier: "LogCell")
    
    searchController = UISearchController(searchResultsController: searchResultsController)
    searchController.searchResultsUpdater = self
    searchController.searchBar.sizeToFit()
    searchController.searchBar.tintColor = UIColor.whiteColor()
    searchController.searchBar.delegate = self
    searchController.searchBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    tableView.tableHeaderView?.addSubview(searchController.searchBar)
    
    definesPresentationContext = true;
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if (searchController.active) {
      return Int(searchResults.count)
    } else {
      return Int(specimens.count)
    }
    
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    var cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as! LogCell
    var specimen: Specimen!
    
    if searchController.active {
        specimen = searchResults[indexPath.row] as Specimen
    } else {
        specimen = specimens[indexPath.row]
    }
    
    cell.titleLabel.text = specimen.name
    cell.subtitleLabel.text = specimen.category.name
    
    switch specimen.category.name {
    case "Uncategorized":
        cell.iconImageView.image = UIImage(named: "IconUncategorized")
    case "Reptiles":
        cell.iconImageView.image = UIImage(named: "IconReptile")
    case "Flora":
        cell.iconImageView.image = UIImage(named: "IconFlora")
    case "Birds":
        cell.iconImageView.image = UIImage(named: "IconBird")
    case "Arachnid":
        cell.iconImageView.image = UIImage(named: "IconArachnid")
    case "Mammals":
        cell.iconImageView.image = UIImage(named: "IconMammal")
    default:
        cell.iconImageView.image = UIImage(named: "IconUncategorized")
    }
    
    if specimen.distance < 0 {
        cell.distanceLabel.text = "N/A"
    } else {
        cell.distanceLabel.text = String(format: "%.2fkm", specimen.distance / 1000)
    }
    
    return cell
    
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
        deleteRowAtIndexPath(indexPath)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//    if (segue.identifier == "Edit") {
//      let controller = segue.destinationViewController as! AddNewEntryController
//      
//      let indexPath = tableView.indexPathForSelectedRow()
//      
//      if searchController.active {
//        let searchResultsController = searchController.searchResultsController as! UITableViewController
//        let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow()
//        
//      }
//      
//    }
    if segue.identifier == "Edit" {
        let controller = segue.destinationViewController as! AddNewEntryController
        var selectedSpecimen: Specimen!
        let indexPath = tableView.indexPathForSelectedRow()
        
        if searchController.active {
            let searchResultsController = searchDisplayController?.searchContentsController as! UITableViewController
            let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow()
            selectedSpecimen = searchResults[indexPath!.row]
        } else {
            selectedSpecimen = specimens[indexPath!.row]
        }
        
        controller.specimen = selectedSpecimen
    }
  }
  
  //MARK: - Actions

  @IBAction func scopeChanged(sender: AnyObject) {
    let scopeBar = sender as! UISegmentedControl
    
    switch scopeBar.selectedSegmentIndex {
    case 0:
        specimens = Realm().objects(Specimen).sorted("name", ascending: true)
    case 1:
        //specimens = Realm().objects(Specimen).sorted("distance", ascending: true) //cant sort ignored property
        break;
    case 2:
        specimens = Realm().objects(Specimen).sorted("created", ascending: true)
    default:
        specimens = Realm().objects(Specimen).sorted("name", ascending: true)
    }
    tableView.reloadData()
  }
  
  
}
