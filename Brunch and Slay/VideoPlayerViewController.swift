//
//  VideoPlayerViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 7/5/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import WebKit

class VideoPlayerViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var videoData: VideoData!
    
    @IBOutlet var videoWebView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoWebView.uiDelegate = self
        //view = videoWebView
        
        //videoWebView.configuration.allowsInlineMediaPlayback = true
        
        let videoURL = URL(string: videoData.videoURLString)
        
        //let videoURL = URL(string: "https://www.apple.com")
        let videoRequest = URLRequest(url: videoURL!)
        
        videoWebView.load(videoRequest)

        // Do any additional setup after loading the view.
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
