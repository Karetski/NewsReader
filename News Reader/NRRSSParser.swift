//
//  NRRSSParser.swift
//  News Reader
//
//  Created by Alexey on 05.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

protocol NSRSSParserDelegate {
    func parsingWasFinished(channel: NRChannel)
}

class NRRSSParser: NSObject {
    var channel: NRChannel = NRChannel()
}
