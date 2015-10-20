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
    var date: String? // Change to NSDate
    
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
    
    var thumbnailImage: UIImage?
    var thumbnail: NSURL? {
        var url: NSURL?
        
        for mediaURL in self.media {
            var stringURL = "\(mediaURL)"
            
            let regex = try! NSRegularExpression(pattern: "(https?)\\S*(png|jpg|jpeg|gif)", options: .CaseInsensitive)
            
            if let result = regex.firstMatchInString(stringURL, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, stringURL.characters.count)) {
                stringURL = (stringURL as NSString).substringWithRange(result.range) as String
                url = NSURL(string: stringURL)
                break
            }
        }
        
        return url
    }
    
    var media = [NSURL]()
    var categories = [String: NSURL]()
    
    func setLinkWithString(urlString: String) {
        self.link = NSURL(string: urlString)
    }
    
    func appendMediaWithString(urlString: String) {
        if let url = NSURL(string: urlString) {
            self.media.append(url)
        }
    }
    
    func appendCategoryWithName(string: String, stringWithURL urlString: String) {
        if let url = NSURL(string: urlString) {
            self.categories[string] = url
        }
    }
}
