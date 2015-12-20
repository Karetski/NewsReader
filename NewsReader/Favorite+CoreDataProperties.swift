//
//  Favorite+CoreDataProperties.swift
//  NewsReader
//
//  Created by Alexey on 20.12.15.
//  Copyright © 2015 Alexey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorite {

    @NSManaged var link: String?
    @NSManaged var name: String?

}
