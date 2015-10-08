//
//  Item.swift
//  News Reader
//
//  Created by Alexey on 02.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NRItem: NSObject {
    var title: String?
    var link: NSURL?
    var itemDescription: String?
    var creator: String?
    var date: String? // Change to NSDate
    
    var media = [NSURL]()
    var categories = [String: NSURL]()
    
    func linkWithString(urlString: String) {
        self.link = NSURL(string: urlString)
    }
    
    func appendMediaWithString(urlString: String) {
        if let url = NSURL(string: urlString) {
            self.media.append(url)
        }
    }
    
    func appendCategoryWithName(string: String, stringWithURL urlString: String) {
        if let url = NSURL(string: urlString) {
            self.categories[string] = url
        }
    }
}
