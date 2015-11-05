//
//  Media.swift
//  News Reader
//
//  Created by Alexey on 03.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class Media: NSObject {
    var link: String
    
    var url: NSURL? {
        if let url = NSURL(string: link) {
            return url
        }
        return nil
    }
    
    init(link: String) {
        self.link = link
    }
}
