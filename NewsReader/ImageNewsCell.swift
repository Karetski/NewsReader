//
//  ImageNewsCell.swift
//  News Reader
//
//  Created by Alexey on 11.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class ImageNewsCell: NewsCell {
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
    }
}
