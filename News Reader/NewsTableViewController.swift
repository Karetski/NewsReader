//
//  NewsTableViewController.swift
//  News Reader
//
//  Created by Alexey on 01.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, RSSParserDelegate {
    var channel: Channel?
    var imageDownloadsInProgress = [NSIndexPath: ImageDownloader]()
    
    var rssLink = "http://www.nytimes.com/services/xml/rss/nyt/World.xml"
    
    let newsCellIdentifier = "NewsCell"
    let imageNewsCellIdentifier = "ImageNewsCell"
    
    let newsDetailSegueIdentifier = "NewsDetailSegue"
    let imageNewsDetailSegueIdentifier = "ImageNewsDetailSegue"
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
        self.beginParsing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button actions
    
    @IBAction func changeRSSSource(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "RSS Source", message: "Change RSS source link", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0]
            if let newLink = textField.text {
                self.rssLink = newLink
            }
            self.beginParsing()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonAction(sender: UIBarButtonItem) {
        self.beginParsing()
    }
    
    // MARK: - Helpers
    
    func sendMessageWithError(error: NSError, withTitle title: String) {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func beginParsing() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let requestURL = NSURL(string: self.rssLink) {
                let parser = RSSParser()
                parser.delegate = self
                parser.parseWithURL(requestURL)
            }
        })
    }
    
    // MARK: - NRRSSParserDelegate
    
    func parsingWasStarted() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let leftBarButtomItem = self.navigationItem.leftBarButtonItem {
                leftBarButtomItem.enabled = false
            }
            self.title = "Loading..."
        })
    }
    
    func parsingWasFinished(channel: Channel?, error: NSError?) {
        if let error = error {
            self.sendMessageWithError(error, withTitle: "Parsing error")
            return
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let channel = channel {
                self.channel = channel
                self.title = channel.title
                self.tableView.reloadData()
            } else {
                if let channel = self.channel {
                    self.title = channel.title
                } else {
                    self.title = "News Reader"
                }
            }
            if let leftBarButtomItem = self.navigationItem.leftBarButtonItem {
                leftBarButtomItem.enabled = true
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let channel = self.channel else {
            return 0
        }
        return channel.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let channel = self.channel else {
            return UITableViewCell()
        }
        if let thumbnail = channel.items[indexPath.row].thumbnail {
            return self.imageNewsCellAtIndexPath(indexPath, channel: channel, thumbnail: thumbnail)
        } else {
            return self.newsCellAtIndexPath(indexPath, channel: channel)
        }
    }
    
    func newsCellAtIndexPath(indexPath: NSIndexPath, channel: Channel) -> NewsCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(newsCellIdentifier) as! NewsCell
        
        let item = channel.items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.minifiedDescription
        cell.dateLabel.text = item.date
        
        return cell
    }
    
    func imageNewsCellAtIndexPath(indexPath: NSIndexPath, channel: Channel, thumbnail: NSURL) -> ImageNewsCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(imageNewsCellIdentifier) as! ImageNewsCell
        
        let item = channel.items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.minifiedDescription
        cell.dateLabel.text = item.date
        
        if let thumbnailImage = item.thumbnailImage {
            cell.thumbnailImageView.image = thumbnailImage
        } else {
            if self.tableView.dragging == false && self.tableView.decelerating == false {
                self.startThumbnailDownload(item, indexPath: indexPath, cell: cell)
            }
            cell.thumbnailImageView.image = UIImage(named: "Placeholder.png")
        }
        
        return cell
    }
    
    // MARK: - Image downloading helpers
    
    func startThumbnailDownload(item: Item, indexPath: NSIndexPath, cell: ImageNewsCell) {
        if let _ = self.imageDownloadsInProgress[indexPath] {
            return
        }
        guard let thumbnailURL = item.thumbnail else {
            return
        }
        let imageDownloader = ImageDownloader()
        imageDownloader.completionHandler = { (image, error) -> Void in
            if let error = error {
                self.sendMessageWithError(error, withTitle: "Image downloading Error")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                cell.thumbnailImageView.image = image
            }
            item.thumbnailImage = image
            
            self.imageDownloadsInProgress.removeValueForKey(indexPath)
        }
        self.imageDownloadsInProgress[indexPath] = imageDownloader
        imageDownloader.downloadImageWithURL(thumbnailURL)
    }
    
    func loadImagesForOnscreenRows() {
        guard let channel = self.channel else {
            return
        }
        guard let visiblePaths = self.tableView.indexPathsForVisibleRows else {
            return
        }
        
        for indexPath in visiblePaths {
            let item = channel.items[indexPath.row]
            if let _ = item.thumbnail {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ImageNewsCell
                self.startThumbnailDownload(item, indexPath: indexPath, cell: cell)
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.loadImagesForOnscreenRows()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == newsDetailSegueIdentifier || segue.identifier == self.imageNewsDetailSegueIdentifier {
            if let destination = segue.destinationViewController as? NewsDetailTableViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    if let channel = self.channel {
                        destination.item = channel.items[indexPath.row]
                    }
                }
            }
        }
    }

}
