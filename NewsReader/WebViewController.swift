//
//  WebViewController.swift
//  News Reader
//
//  Created by Alexey on 24.10.15.
//  Copyright © 2015 Alexey. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityBackground: UIVisualEffectView!
    @IBOutlet weak var customNavigationItem: UINavigationItem!
    
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = self.url else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.webView.loadRequest(request)
            self.customNavigationItem.title = url.absoluteString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button actions
    
    @IBAction func copyAction(sender: AnyObject) {
        guard let url = self.url else {
            return
        }
        UIPasteboard.generalPasteboard().string = url.absoluteString
        
        let alert = UIAlertController(title: "Added", message: "URL Added to clipboard", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.activityIndicator.startAnimating()
        self.activityBackground.hidden = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicator.stopAnimating()
        self.activityBackground.hidden = true
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
