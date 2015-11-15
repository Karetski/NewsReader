//
//  NRRSSParserDelegate.swift
//  News Reader
//
//  Created by Alexey on 05.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

protocol RSSParserDelegate {
    func parsingWasStarted()
    func parsingWasFinished(error: NSError?)
}

