//
//  WebPaymentViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/26/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import WebKit

class WebPaymentViewController: UIViewController, WKUIDelegate, WKNavigationDelegate{
    
    
    @IBOutlet weak var webView: WKWebView!
    var redirectURLString: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        
        // Do any additional setup after loading the view.
        let redirectURL = URL(string: redirectURLString)
        let myRequest = URLRequest(url: redirectURL!)
        webView.load(myRequest)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
