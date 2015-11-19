//
//  Channel+CoreDataProperties.swift
//  News Reader
//
//  Created by Alexey on 15.11.15.
//  Copyright © 2015 Alexey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Channel {
    @NSManaged var channelDescription: String?
    @NSManaged var copyright: String?
    @NSManaged var date: String?
    @NSManaged var language: String?
    @NSManaged var link: String?
    @NSManaged var title: String?
    
    @NSManaged var items: NSOrderedSet?
}
