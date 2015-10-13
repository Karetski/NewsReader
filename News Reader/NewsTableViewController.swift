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
    
    var rssLink = "http://www.nytimes.com/services/xml/rss/nyt/World.xml"
    
    let newsCellIdentifier = "NewsCell"
    let imageNewsCellIdentifier = "ImageNewsCell"
    let newsDetailSegueIdentifier = "NewsDetailSegue"
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
        self.beginParsing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Button actions
    
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
    
    // MARK: Parser loading
    
    func beginParsing() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let requestURL = NSURL(string: self.rssLink) {
                let parser = RSSParser()
                parser.delegate = self
                parser.parseWithURL(requestURL)
            }
        })
    }
    
    // MARK: - NRRSSParserDelegate implementation
    
    func parsingWasStarted() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let leftBarButtomItem = self.navigationItem.leftBarButtonItem {
                leftBarButtomItem.enabled = false
            }
            self.title = "Loading..."
        })
    }
    
    func parsingWasFinished(channel: Channel?, error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if let leftBarButtomItem = self.navigationItem.leftBarButtonItem {
                leftBarButtomItem.enabled = true
            }
        })
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
    
    func imageNewsCellAtIndexPath(indexPath: NSIndexPath, channel: Channel, thumbnail: NSURL) -> ImageNewsCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(imageNewsCellIdentifier) as! ImageNewsCell
        
        let item = channel.items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.itemDescription
        cell.thumbnailImageView.setImageFromURL(thumbnail, contentMode: .ScaleAspectFit)
        cell.dateLabel.text = item.date
        
        return cell
    }
    
    func newsCellAtIndexPath(indexPath: NSIndexPath, channel: Channel) -> NewsCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(newsCellIdentifier) as! NewsCell
        
        let item = channel.items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.itemDescription
        cell.dateLabel.text = item.date
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == newsDetailSegueIdentifier {
            if let destination = segue.destinationViewController as? NewsDetailViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    if let channel = self.channel {
                        destination.item = channel.items[indexPath.row]
                    }
                }
            }
        }
    }

}
