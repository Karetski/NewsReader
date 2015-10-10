//
//  NewsCell.swift
//  News Reader
//
//  Created by Alexey on 10.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
