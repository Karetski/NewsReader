//
//  NRRSSParser.swift
//  News Reader
//
//  Created by Alexey on 05.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

protocol NSRSSParserDelegate {
    func parsingWasFinished(channel: NRChannel?, error: NSError?)
}

class NRRSSParser: NSObject, NSXMLParserDelegate {
    var channel: NRChannel = NRChannel()
    
    var delegate: NSRSSParserDelegate?
    
    func startParsingWithData(data: NSData) {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: NSXMLParserDelegate implementation
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.delegate?.parsingWasFinished(self.channel, error: nil)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.delegate?.parsingWasFinished(nil, error: parseError)
    }
}
