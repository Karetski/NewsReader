//
//  NRRSSParser.swift
//  News Reader
//
//  Created by Alexey on 05.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NRRSSParser: NSObject, NSXMLParserDelegate {
    var channel = NRChannel()
    var activeItem: NRItem?
    var activeElement = ""
    var activeAttributes: [String: String]?
    
    let node_title = "title"
    let node_link = "link"
    let node_description = "description"
    let node_category = "category"
    let node_creator = "creator"
    let node_pubDate = "pubDate"
    let node_language = "language"
    let node_copyright = "copyright"
    let node_media = "media:content"
    
    let attr_url = "url"
    let attr_domain = "domain"
    
    var delegate: NRRSSParserDelegate?
    
    func startParsingWithRequest(request: NSURLRequest) {
        self.delegate?.parsingWasStarted()
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if error != nil {
                self.delegate?.parsingWasFinished(nil, error: error)
            } else {
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
            }
        })
        
        task.resume()
    }
    
    // MARK: - NSXMLParserDelegate implementation
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.delegate?.parsingWasFinished(self.channel, error: nil)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.delegate?.parsingWasFinished(nil, error: parseError)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            self.activeItem = NRItem()
        }
        self.activeElement = ""
        self.activeAttributes = attributeDict
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.activeElement += string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let item = self.activeItem {
                self.channel.items.append(item)
            }
            self.activeItem = nil
            return
        }
        if let item = self.activeItem {
            if elementName == "title" {
                item.title = self.activeElement
            }
            if elementName == "link" {
                item.linkWithString(self.activeElement)
            }
            if elementName == "description" {
                item.itemDescription = self.activeElement
            }
            if elementName == "category" {
                if let attributes = self.activeAttributes {
                    if let url = attributes[self.attr_domain] {
                        item.appendCategoryWithName(self.activeElement, stringWithURL: url)
                    }
                }
                self.activeAttributes = nil
            }
            if elementName == "dc:creator" {
                item.creator = self.activeElement
            }
            if elementName == "pubDate" {
                item.date = self.activeElement
            }
            if elementName == node_media {
                if let attributes = self.activeAttributes {
                    if let url = attributes[self.attr_url] {
                        item.appendMediaWithString(url)
                    }
                }
                self.activeAttributes = nil
            }
        } else {
            if elementName == "title" {
                self.channel.title = self.activeElement
            }
            if elementName == "link" {
                self.channel.linkWithString(self.activeElement)
            }
            if elementName == "description" {
                self.channel.channelDescription = self.activeElement
            }
            if elementName == "language" {
                self.channel.language = self.activeElement
            }
            if elementName == "copyright" {
                self.channel.copyright = self.activeElement
            }
            if elementName == "pubDate" {
                self.channel.date = self.activeElement
            }
        }
    }
}
