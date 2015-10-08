//
//  Channel.swift
//  News Reader
//
//  Created by Alexey on 02.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NRChannel: NSObject {
    var title: String?
    var link: NSURL?
    var channelDescription: String?
    var language: String?
    var copyright: String?
    var date: String? // Change to NSDate
    
    var items = [NRItem]()
    
    func linkWithString(string: String) {
        self.link = NSURL(string: string)
    }
}
