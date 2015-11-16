//
//  NewsDetailViewController.swift
//  News Reader
//
//  Created by Alexey on 08.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NewsDetailTableViewController: UITableViewController {
    
    var item: Item?
    
    let detailNewsCellIdentifier = "DetailNewsCell"
    let categoriesNewsCellIdentifier = "CategoriesNewsCell"
    let mediaNewsCellIdentifier = "MediaNewsCell"
    
    let itemLinkSegueIdentifier = "ItemLinkSegue"
    let categoryLinkSegueIdentifier = "CategoryLinkSegue"
    let mediaLinkSegueIdentifier = "MediaLinkSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
    }
    
    override func viewWillAppear(animated: Bool) {
        if let item = self.item {
            self.title = item.title
        }
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let _ = self.item else {
            return 1
        }
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let item = self.item {
            if section == 1 && item.categories!.count > 0 {
                return "Categories"
            } else if section == 2 && item.media!.count > 0 {
                return "Media"
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let item = self.item {
            if section == 0 {
                return 1
            } else if section == 1 {
                return item.categories!.count
            } else if section == 2 {
                return item.media!.count
            }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let item = self.item else {
            return UITableViewCell()
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.categoriesNewsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            
            let category = item.categories![indexPath.row] as! Category
            cell.textLabel?.text = category.name
            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.mediaNewsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            
            let media = item.media![indexPath.row] as! Media
            cell.textLabel?.text = media.link
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.detailNewsCellIdentifier) as! DetailNewsCell
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.date
        cell.authorLabel.text = item.creator
        cell.descriptionLabel.text = item.minifiedDescription
        if let image = item.thumbnailImage {
            cell.thumbnailImageView.image = image
        } else if let imageURL = item.thumbnail {
            cell.thumbnailImageView.setImageFromURL(imageURL)
        }
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let item = self.item else {
            return
        }
        guard let destination = segue.destinationViewController as? WebViewController else {
            return
        }
        
        if segue.identifier == self.itemLinkSegueIdentifier {
            guard let url = item.url else {
                return
            }
            destination.url = url
            return
        }
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        if segue.identifier == self.categoryLinkSegueIdentifier {
            let category = item.categories![indexPath.row] as! Category
            guard let url = category.url else {
                return
            }
            destination.url = url
            return
        }
        if segue.identifier == self.mediaLinkSegueIdentifier {
            let media = item.media![indexPath.row] as! Media
            guard let url = media.url else {
                return
            }
            destination.url = url
            return
        }
    }
}
