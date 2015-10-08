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
    var categories = [String]()
    
    func linkWithString(string: String) {
        self.link = NSURL(string: string)
    }
    
    func appendMediaWithString(string: String) {
        if let url = NSURL(string: string) {
            self.media.append(url)
        }
    }
}
