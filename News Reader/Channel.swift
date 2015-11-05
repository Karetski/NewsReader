//
//  Channel.swift
//  News Reader
//
//  Created by Alexey on 02.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class Channel: NSObject {
    var title: String?
    var link: NSURL?
    var channelDescription: String?
    var language: String?
    var copyright: String?
    var date: String? 
    
    var items = [Item]()
    
    func setLinkWithString(link: String) {
        self.link = NSURL(string: link)
    }
}
