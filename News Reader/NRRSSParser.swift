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
    
    var delegate: NRRSSParserDelegate?
    
    func startParsingWithRequest(request: NSURLRequest) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if ((error) != nil) {
                self.delegate?.parsingWasFinished(nil, error: error)
            } else {
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
            }
        })
        
        task.resume()
    }
    
    // MARK: NSXMLParserDelegate implementation
    
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
                item.link = self.activeElement
            }
            if elementName == "description" {
                item.itemDescription = self.activeElement
            }
        } else {
            if elementName == "title" {
                self.channel.title = self.activeElement
            }
            if elementName == "link" {
                self.channel.link = self.activeElement
            }
            if elementName == "description" {
                self.channel.channelDescription = self.activeElement
            }
        }
    }
}
