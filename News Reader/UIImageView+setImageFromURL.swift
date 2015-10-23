//
//  UIImageView+setImageFromURL.swift
//  News Reader
//
//  Created by Alexey on 12.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageFromURL(url: NSURL) {
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard let data = data where error == nil else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = UIImage(data: data)
            }
        }).resume()
    }
}




