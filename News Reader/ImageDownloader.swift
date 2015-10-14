//
//  ImageDownloader.swift
//  News Reader
//
//  Created by Alexey on 14.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    var completionHandler: ((UIImage?, NSError?) -> Void)!
    
    func downloadImageWithURL(url: NSURL) {
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            if let data = data {
                let image = UIImage(data: data)
                self.completionHandler(image, nil)
                
            } else {
                self.completionHandler(nil, error)
            }
        }).resume()
    }
}
