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
    let detailImageNewsCellIdentifier = "DetailImageNewsCell"
    let categoriesNewsCellIdentifier = "CategoriesNewsCell"
    let mediaNewsCellIdentifier = "MediaNewsCell"
    
    let itemLinkSegueIdentifier = "ItemLinkSegue"
    let categoryLinkSegueIdentifier = "CategoryLinkSegue"
    let mediaLinkSegueIdentifier = "MediaLinkSegue"
    let drawingSegueIdentifier = "DrawingSegue"
    
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
    
    // MARK: - Unwind segues
    
    @IBAction func drawingExitSegue(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func webExitSegue(segue:UIStoryboardSegue) {
        
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
        
        guard let imageURL = item.thumbnail else {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.detailNewsCellIdentifier) as! DetailNewsCell
            
            cell.titleLabel.text = item.title
            cell.dateLabel.text = item.date
            cell.authorLabel.text = item.creator
            cell.descriptionLabel.text = item.minifiedDescription
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.detailImageNewsCellIdentifier) as! DetailImageNewsCell
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.date
        cell.authorLabel.text = item.creator
        cell.descriptionLabel.text = item.minifiedDescription
        if let image = item.thumbnailImage {
            cell.thumbnailImageView.image = image
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            cell.thumbnailImageView.setImageFromURL(imageURL)
        }
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let item = self.item else {
            return
        }
        
        if segue.identifier == self.mediaLinkSegueIdentifier || segue.identifier == self.itemLinkSegueIdentifier || segue.identifier == self.categoryLinkSegueIdentifier {
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
        } else {
            guard let destination = segue.destinationViewController as? DrawingViewController else {
                return
            }
            
            if segue.identifier == self.drawingSegueIdentifier {
                if let thumbnailImage = item.thumbnailImage {
                    destination.sourceImage = thumbnailImage
                }
            }
        }
    }
}
