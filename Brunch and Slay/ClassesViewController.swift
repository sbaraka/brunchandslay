//
//  ClassesViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import WebKit

class ClassesViewController: UIViewController{
    @IBOutlet weak var youtubewebview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getVideo(videoCode: "WR4QQsNm1ok")
    }
    func getVideo(videoCode:String){
        let url = URL(string:"https://www.youtube.com/embed/\(videoCode)")
        youtubewebview.load(URLRequest(url: url!))
    }
}
