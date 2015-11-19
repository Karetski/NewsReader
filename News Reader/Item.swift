//
//  Item.swift
//  News Reader
//
//  Created by Alexey on 02.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit
import CoreData

class Item: NSManagedObject {
    var minifiedDescription: String? {
        guard let description = self.itemDescription else {
            return nil
        }
        
        var resultString = description
        var tags = [String]()
        
        let regex = try! NSRegularExpression(pattern: "<(.*?)>", options: .CaseInsensitive)
        regex.enumerateMatchesInString(description, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, description.characters.count)) { (result, _, _) in
            if let result = result {
                let string = (description as NSString).substringWithRange(result.range) as String
                tags.append(string)

            }
        }
        
        for tag in tags {
            resultString = resultString.stringByReplacingOccurrencesOfString(tag, withString: "")
        }
        
        return resultString
    }
    
    var thumbnailImage: UIImage? {
        set {
            if let image = newValue {
                if let data = UIImagePNGRepresentation(image) {
                    self.thumbnailData = data
                }
            }
        }
        get {
            guard let data = self.thumbnailData else {
                return nil
            }
            guard let image = UIImage(data: data) else {
                return nil
            }
            return image
        }
    }
    
    var thumbnail: NSURL? {
        var url: NSURL?
        
        guard let media = self.media else {
            return url
        }
        
        for item in media.array {
            let mediaItem = item as! Media
            guard let mediaLink = mediaItem.link else {
                continue
            }
            
            var stringURL = mediaLink
            
            let regex = try! NSRegularExpression(pattern: "(https?)\\S*(png|jpg|jpeg|gif)", options: .CaseInsensitive)
            
            if let result = regex.firstMatchInString(stringURL, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, stringURL.characters.count)) {
                stringURL = (stringURL as NSString).substringWithRange(result.range) as String
                url = NSURL(string: stringURL)
                break
            }
        }
        
        return url
    }
    
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
