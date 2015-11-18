//
//  NRRSSParser.swift
//  News Reader
//
//  Created by Alexey on 05.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit
import CoreData

class RSSParser: NSObject, NSXMLParserDelegate {
    private var channel: Channel!
    private var activeItem: Item?
    private var activeElement = ""
    private var activeAttributes: [String: String]?
    private var lastPubDate: String?
    private var isOldChannel: Bool = false
    
    var managedContext: NSManagedObjectContext!
    
    let node_channel = "channel"
    let node_item = "item"
    let node_title = "title"
    let node_link = "link"
    let node_description = "description"
    let node_category = "category"
    let node_creator = "dc:creator"
    let node_pubDate = "pubDate"
    let node_language = "language"
    let node_copyright = "copyright"
    let node_mediaContent = "media:content"
    
    let attr_url = "url"
    let attr_domain = "domain"
    
    var delegate: RSSParserDelegate?
    
    func parseWithURL(url: NSURL, intoManagedObjectContext managedContext: NSManagedObjectContext) {
        self.parseWithRequest(NSURLRequest(URL: url), intoManagedObjectContext: managedContext)
    }
    
    func parseWithRequest(request: NSURLRequest, intoManagedObjectContext managedContext: NSManagedObjectContext) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.delegate?.parsingWasStarted()
        }
        
        self.managedContext = managedContext
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if let error = error {
                self.managedContext.rollback()
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.delegate?.parsingWasFinished(error)
                }
            } else {
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
            }
        }).resume()
    }
    
    // MARK: - NSXMLParserDelegate implementation
    
    func parserDidEndDocument(parser: NSXMLParser) {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.delegate?.parsingWasFinished(nil)
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.managedContext.rollback()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if self.isOldChannel {
                self.delegate?.parsingWasFinished(nil)
            } else {
                self.delegate?.parsingWasFinished(parseError)
            }
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == self.node_channel {
            let channelEntity = NSEntityDescription.entityForName("Channel", inManagedObjectContext: managedContext)
            let channelFetch = NSFetchRequest(entityName: "Channel")
            
            do {
                let results = try self.managedContext.executeFetchRequest(channelFetch) as! [Channel]
                
                if let channel = results.first {
                    self.lastPubDate = channel.date
                    self.managedContext.deleteObject(channel)
                }
                
                self.channel = Channel(entity: channelEntity!, insertIntoManagedObjectContext: self.managedContext)
            } catch let error as NSError {
                print("Error: \(error) " + "description \(error.localizedDescription)")
            }
        }
        if elementName == self.node_item {
            let itemEntity = NSEntityDescription.entityForName("Item", inManagedObjectContext: managedContext)
            
            self.activeItem = Item(entity: itemEntity!, insertIntoManagedObjectContext: self.managedContext)
        }
        self.activeElement = ""
        self.activeAttributes = attributeDict
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.activeElement += string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == self.node_item {
            if let item = self.activeItem {
                let items = self.channel.items!.mutableCopy() as! NSMutableOrderedSet
                
                items.addObject(item)
                
                self.channel.items = items.copy() as? NSOrderedSet
            }
            self.activeItem = nil
            return
        }
        if let item = self.activeItem {
            if elementName == self.node_title {
                item.title = self.activeElement
            }
            if elementName == self.node_link {
                item.link = self.activeElement
            }
            if elementName == self.node_description {
                item.itemDescription = self.activeElement
            }
            if elementName == self.node_category {
                if let attributes = self.activeAttributes {
                    if let url = attributes[self.attr_domain] {
                        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.managedContext)
                        
                        let category = Category(entity: categoryEntity!, insertIntoManagedObjectContext: self.managedContext)
                        
                        category.name = self.activeElement
                        category.link = url
                        
                        let categories = item.categories!.mutableCopy() as! NSMutableOrderedSet
                        categories.addObject(category)
                        item.categories = categories.copy() as? NSOrderedSet
                    }
                }
                self.activeAttributes = nil
            }
            if elementName == self.node_creator {
                item.creator = self.activeElement
            }
            if elementName == self.node_pubDate {
                item.date = self.activeElement
            }
            if elementName == node_mediaContent {
                if let attributes = self.activeAttributes {
                    if let url = attributes[self.attr_url] {
                        let mediaEntity = NSEntityDescription.entityForName("Media", inManagedObjectContext: self.managedContext)
                        
                        let media = Media(entity: mediaEntity!, insertIntoManagedObjectContext: self.managedContext)
                        
                        media.link = url
                        
                        let medias = item.media!.mutableCopy() as! NSMutableOrderedSet
                        medias.addObject(media)
                        item.media = medias.copy() as? NSOrderedSet
                    }
                }
                self.activeAttributes = nil
            }
        } else {
            if elementName == self.node_title {
                self.channel.title = self.activeElement
            }
            if elementName == self.node_link {
                self.channel.link = self.activeElement
            }
            if elementName == self.node_description {
                self.channel.channelDescription = self.activeElement
            }
            if elementName == self.node_language {
                self.channel.language = self.activeElement
            }
            if elementName == self.node_copyright {
                self.channel.copyright = self.activeElement
            }
            if elementName == self.node_pubDate {
                if let lastPubDate = self.lastPubDate {
                    if lastPubDate == self.activeElement {
                        self.isOldChannel = true
                        parser.abortParsing()
                    }
                }
                self.channel.date = self.activeElement
            }
        }
    }
}
