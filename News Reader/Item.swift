//
//  Item.swift
//  News Reader
//
//  Created by Alexey on 02.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class Item: NSObject {
    var title: String?
    var link: NSURL?
    var creator: String?
    var date: String?
    
    var itemDescription: String?
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
    
    var thumbnailData: NSData?
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
        
        for media in self.media {
            var stringURL = media.link
            
            let regex = try! NSRegularExpression(pattern: "(https?)\\S*(png|jpg|jpeg|gif)", options: .CaseInsensitive)
            
            if let result = regex.firstMatchInString(stringURL, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, stringURL.characters.count)) {
                stringURL = (stringURL as NSString).substringWithRange(result.range) as String
                url = NSURL(string: stringURL)
                break
            }
        }
        
        return url
    }
    
    var media = [Media]()
    var categories = [Category]()
    
    func setLinkWithString(link: String) {
        self.link = NSURL(string: link)
    }
    
    func appendMediaWithString(link: String) {
        let media = Media(link: link)
        self.media.append(media)
    }
    
    func appendCategoryWithName(name: String, stringWithURL link: String) {
        let category = Category(name: name, link: link)
        self.categories.append(category)
    }
}
