//
//  FavoritesTableViewController.swift
//  NewsReader
//
//  Created by Alexey on 20.12.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var managedContext: NSManagedObjectContext!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    let favoritesCellIdentifier = "FavoritesCell"
    
    let favoritesExitSegueIdentifier = "FavoritesExitSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Favorite")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error:\(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button actions
    
    @IBAction func addFavoriteAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Favorites", message: "Add new RSS Channel", preferredStyle: .Alert)
        
        let addFavoriteAction = UIAlertAction(title: "Add", style: .Default, handler: { (action: UIAlertAction!) in
            let nameTextField = alert.textFields![0]
            let linkTextField = alert.textFields![1]
            
            let favorite = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: self.managedContext) as! Favorite
            
            favorite.name = nameTextField.text
            favorite.link = linkTextField.text
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Error: \(error) " + "description \(error.localizedDescription)")
            }
        })
        addFavoriteAction.enabled = false
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) in
            textField.placeholder = "Name"
        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) in
            textField.placeholder = "Link"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                if let link = textField.text {
                    if link.hasSuffix(".xml") || link.hasSuffix(".rss") {
                        addFavoriteAction.enabled = true
                    }
                }
            }
        }
        
        alert.addAction(addFavoriteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.favoritesCellIdentifier, forIndexPath: indexPath)

        let favorite = fetchedResultsController.objectAtIndexPath(indexPath) as! Favorite
        
        cell.textLabel?.text = favorite.name
        cell.detailTextLabel?.text = favorite.link

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let favorite = fetchedResultsController.objectAtIndexPath(indexPath) as! Favorite
            
            self.managedContext.deleteObject(favorite)
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Error: \(error) " + "description \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller:
        NSFetchedResultsController) {
            self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Insert {
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        } else if type == .Delete {
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        } else if type == .Move {
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == favoritesExitSegueIdentifier {
            if let destination = segue.destinationViewController as? NewsTableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let favorite = fetchedResultsController.objectAtIndexPath(indexPath) as! Favorite
                    guard let link = favorite.link else {
                        return
                    }
                    destination.rssLink = link
                }
            }
        }
    }
}
