//
//  NewsDetailViewController.swift
//  News Reader
//
//  Created by Alexey on 08.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    var item: NRItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = self.item {
            self.title = item.title
            print(item.thubmnail)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
