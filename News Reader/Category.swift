//
//  Category.swift
//  News Reader
//
//  Created by Alexey on 03.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit
import CoreData

class Category: NSManagedObject {
    
    var url: NSURL? {
        guard let link  = self.link else {
            return nil
        }
        if let url = NSURL(string: link) {
            return url
        }
        return nil
    }
    
}
