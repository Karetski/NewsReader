//
//  NewsTableViewController.swift
//  News Reader
//
//  Created by Alexey on 01.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, NRRSSParserDelegate {
    
    var channel: NRChannel?
    var rssLink = "http://www.nytimes.com/services/xml/rss/nyt/World.xml"
    
    let textCellIdentifier = "NewsCell"
    
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
    
    func beginParsing() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let request = NSURLRequest(URL: NSURL(string: self.rssLink)!)
            let parser = NRRSSParser()
            parser.delegate = self
            parser.startParsingWithRequest(request)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beginParsing()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: NRRSSParserDelegate implementation
    func parsingWasStarted() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.title = "Loading..."
        })
    }
    
    func parsingWasFinished(channel: NRChannel?, error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let currentChannel = channel {
                self.channel = currentChannel
                self.title = currentChannel.title
                self.tableView.reloadData()
            } else {
                if let currentChannel = self.channel {
                    self.title = currentChannel.title
                } else {
                    self.title = "News Reader"
                }
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let channel = self.channel {
            return channel.items.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        if let channel = self.channel {
            let item = channel.items[row]
            cell.textLabel?.text = item.title
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
