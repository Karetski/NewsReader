//
//  Favorite.swift
//  NewsReader
//
//  Created by Alexey on 20.12.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import Foundation
import CoreData


class Favorite: NSManagedObject {
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
